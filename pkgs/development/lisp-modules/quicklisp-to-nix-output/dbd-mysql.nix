args @ { fetchurl, ... }:
rec {
  baseName = ''dbd-mysql'';
  version = ''cl-dbi-20190107-git'';

  description = ''Database driver for MySQL.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl-annot" args."cl-mysql" args."cl-syntax" args."cl-syntax-annot" args."closer-mop" args."dbi" args."named-readtables" args."split-sequence" args."trivial-features" args."trivial-types" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2019-01-07/cl-dbi-20190107-git.tgz'';
    sha256 = ''02w729jfkbd8443ia07ixr53b4asxx2gcllr84hvlibafawkkdh2'';
  };

  packageName = "dbd-mysql";

  asdFilesToKeep = ["dbd-mysql.asd"];
  overrides = x: x;
}
/* (SYSTEM dbd-mysql DESCRIPTION Database driver for MySQL. SHA256
    02w729jfkbd8443ia07ixr53b4asxx2gcllr84hvlibafawkkdh2 URL
    http://beta.quicklisp.org/archive/cl-dbi/2019-01-07/cl-dbi-20190107-git.tgz
    MD5 349829f5d0bf363b828827ad6728c54e NAME dbd-mysql FILENAME dbd-mysql DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cl-annot FILENAME cl-annot)
     (NAME cl-mysql FILENAME cl-mysql) (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME closer-mop FILENAME closer-mop) (NAME dbi FILENAME dbi)
     (NAME named-readtables FILENAME named-readtables)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cl-annot cl-mysql cl-syntax
     cl-syntax-annot closer-mop dbi named-readtables split-sequence
     trivial-features trivial-types)
    VERSION cl-dbi-20190107-git SIBLINGS
    (cl-dbi dbd-postgres dbd-sqlite3 dbi-test dbi) PARASITES NIL) */
