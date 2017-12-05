args @ { fetchurl, ... }:
rec {
  baseName = ''qmynd'';
  version = ''20170630-git'';

  description = ''MySQL Native Driver'';

  deps = [ args."babel" args."flexi-streams" args."ironclad" args."list-of" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/qmynd/2017-06-30/qmynd-20170630-git.tgz'';
    sha256 = ''01rg2rm4n19f5g39z2gdjcfy68z7ir51r44524vzzs0x9na9y6bi'';
  };

  packageName = "qmynd";

  asdFilesToKeep = ["qmynd.asd"];
  overrides = x: x;
}
/* (SYSTEM qmynd DESCRIPTION MySQL Native Driver SHA256
    01rg2rm4n19f5g39z2gdjcfy68z7ir51r44524vzzs0x9na9y6bi URL
    http://beta.quicklisp.org/archive/qmynd/2017-06-30/qmynd-20170630-git.tgz
    MD5 64776472d1e0c4c0e41a1b4a2a24167e NAME qmynd FILENAME qmynd DEPS
    ((NAME babel FILENAME babel) (NAME flexi-streams FILENAME flexi-streams)
     (NAME ironclad FILENAME ironclad) (NAME list-of FILENAME list-of)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (babel flexi-streams ironclad list-of trivial-gray-streams usocket) VERSION
    20170630-git SIBLINGS (qmynd-test) PARASITES NIL) */
