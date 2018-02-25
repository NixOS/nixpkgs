args @ { fetchurl, ... }:
rec {
  baseName = ''qmynd'';
  version = ''20180131-git'';

  description = ''MySQL Native Driver'';

  deps = [ args."alexandria" args."asdf-finalizers" args."babel" args."bordeaux-threads" args."cffi" args."chipz" args."cl_plus_ssl" args."flexi-streams" args."ironclad" args."list-of" args."nibbles" args."salza2" args."split-sequence" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/qmynd/2018-01-31/qmynd-20180131-git.tgz'';
    sha256 = ''1ripapyrpzp36wsb2xf8w63nf0cjc13xh6xx296p8wgi01jwm61c'';
  };

  packageName = "qmynd";

  asdFilesToKeep = ["qmynd.asd"];
  overrides = x: x;
}
/* (SYSTEM qmynd DESCRIPTION MySQL Native Driver SHA256
    1ripapyrpzp36wsb2xf8w63nf0cjc13xh6xx296p8wgi01jwm61c URL
    http://beta.quicklisp.org/archive/qmynd/2018-01-31/qmynd-20180131-git.tgz
    MD5 60177d28b1945234fd72760007194b3e NAME qmynd FILENAME qmynd DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME asdf-finalizers FILENAME asdf-finalizers)
     (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME chipz FILENAME chipz)
     (NAME cl+ssl FILENAME cl_plus_ssl)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME ironclad FILENAME ironclad) (NAME list-of FILENAME list-of)
     (NAME nibbles FILENAME nibbles) (NAME salza2 FILENAME salza2)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria asdf-finalizers babel bordeaux-threads cffi chipz cl+ssl
     flexi-streams ironclad list-of nibbles salza2 split-sequence
     trivial-features trivial-garbage trivial-gray-streams usocket)
    VERSION 20180131-git SIBLINGS (qmynd-test) PARASITES NIL) */
