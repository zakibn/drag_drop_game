import 'package:audioplayers/audioplayers.dart';
import 'package:drag_drop_game/itemModel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var player = AudioCache();
  late List<ItemModel> items; //كان
  late List<ItemModel> items2;
  late int score;
  late bool gameOver;
  /* بداية اللعبة */
  initGame() {
    /* اعطي المتغيرات القيم التالية النتيجة 0 وال قايم اوفر قيمة خطا و و   */
    gameOver = false;
    score = 0;
    items = [
      ItemModel(name: 'lion', img: 'Lion', value:   'assets/images/lion.png'),
      ItemModel(name: 'camel', img: 'Camel', value: 'assets/images/camel.png'),
      ItemModel(name: 'cat', img: 'Cat', value:     'assets/images/cat.png'),
      ItemModel(name: 'cow', img: 'Cow', value:     'assets/images/cow.png'),
      ItemModel(name: 'dog', img: 'Dog', value:     'assets/images/dog.png'),
      ItemModel(name: 'fox', img: 'Fox', value:     'assets/images/fox.png'),
      ItemModel(name: 'hen', img: 'Hen', value:     'assets/images/hen.png'),
      ItemModel(name: 'horse', img: 'Horse', value: 'assets/images/horse.png'),
      ItemModel(name: 'panda', img: 'Panda', value: 'assets/images/panda.png'),
      ItemModel(name: 'sheep', img: 'Sheep', value: 'assets/images/sheep.png'),
    ];
    /* الليست الثانية عبارة عن نسخة من الليست الاولى بدلا من تكرارهالكن لم افهم جيدا */
    items2 = List<ItemModel>.from(items);
    /* شوفل معناه اعرض الليست بشكل عشوائي في كل مرة يفتح فيها التطبيق */
    items.shuffle();
    items2.shuffle();
  }

/* عندما تعمل هذه الصفحة الهوم سكرين سوف نقوم بتهيئة اللعبة في البداية  */
  @override
  void initState() {
    super.initState();
    initGame();
    /* هنا التصميم */
  }

  @override
  Widget build(BuildContext context) {
    // if (items.length == 0) gameOver = true;
    if (items.isEmpty) gameOver = true;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: 'score: ',
                  style: Theme.of(context).textTheme.subtitle1),
              TextSpan(
                text: '$score',
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Colors.teal),
              )
            ])),
          ),
          if (!gameOver)
            /* لكي نعرض داخله عمودين */
            Row(
              children: [
                const Spacer(),
                Column(
                  children: items.map((items) {
                    return Container(
                      margin: const EdgeInsets.all(8),
                      child: Draggable<ItemModel>(
                        /* تطلب منك الداتا التي تود سحبها */
                        data: items,
                        /*  الصورة المسحوبة هي نفسها ولكن بحجم مختلف*/
                        childWhenDragging: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(items.img),
                          radius: 50,
                        ),
                        /* الشيئ المسحوب واعطيناه حجم مختلف */
                        feedback: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(items.img),
                          radius: 30,
                        ),
                        /* العنصر اي العنصر من القائمة صورة الحيوان  */
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(items.img),
                          radius: 30,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const Spacer(flex: 2),
                Column(
                  children: items2.map((item) {
                    /* الهدف الذي ستلقي عليه */
                    return DragTarget<ItemModel>(
                        /* اكسبت عبارة عن دالة */
                        onAccept: (receivedItem) {
                          if (items[items.indexOf(item)].value ==
                              receivedItem.value) {
                            setState(() {
                              items.remove(receivedItem);
                              items2.remove(item);
                            });
                            score += 10;
                            item.accepting = false;
                            player.play('true.wave');
                          } else {
                            setState(() {
                              score -= 5;
                              item.accepting = false;
                              player.play('false.wave');
                            });
                          }
                        },
                        onWillAccept: (receivedItem) {
                          setState(() {
                            /* تغيير لون الهدف  */
                            item.accepting = true;
                          });
                          return true;
                        },
                        /* عندما يغادر الحيوان ولا يكون فوق الهدف يرجع لونها كما كان */
                        onLeave: (receivedItem) {
                          setState(() {
                            item.accepting = false;
                          });
                        },
                        builder: ((context, acceptedItem, rejecteditem) =>
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: item.accepting
                                    ? Colors.grey[400]
                                    : Colors.grey[200],
                              ),
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.width / 6.5,
                              width: MediaQuery.of(context).size.width / 3,
                              margin: const EdgeInsets.all(8),
                              child: Text(
                                item.name,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            )));
                  }).toList(),
                ),
                /* const */ const Spacer(),
              ],
            ),
          if (gameOver)
            Center(
              child: Column(children: [
                Padding(
                    padding: /* const */ const EdgeInsets.all(8.0),
                    child: Text(
                      'Game Over',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    result(),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                )
              ]),
            ),
          if (gameOver)
            Container(
              height: MediaQuery.of(context).size.width / 10,
              decoration: BoxDecoration(
                  color: Colors.teal, borderRadius: BorderRadius.circular(8)),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    initGame();
                  });
                },
                child: const Text(
                  'new Game',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
        ],
      ))),
    );
  }

  String result() {
    if (score == 100) {
      player.play('success.wav');
      return 'Awesome!';
    } else {
      player.play('tryAgin.wav');
      return 'try again to get better score';
    }
  }
}
