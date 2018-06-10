args @ { fetchurl, ... }:
rec {
  baseName = ''dbd-mysql'';
  version = ''cl-dbi-20180430-git'';

  description = ''Database driver for MySQL.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl-annot" args."cl-mysql" args."cl-syntax" args."cl-syntax-annot" args."closer-mop" args."dbi" args."named-readtables" args."split-sequence" args."trivial-features" args."trivial-types" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2018-04-30/cl-dbi-20180430-git.tgz'';
    sha256 = ''0bjkba9z93h2sf9n40dvmw1p6nq2p3d5zw9w3zw9k1crn7a601sv'';
  };

  packageName = "dbd-mysql";

  asdFilesToKeep = ["dbd-mysql.asd"];
  overrides = x: x;
}
/* (SYSTEM dbd-mysql DESCRIPTION Database driver for MySQL. SHA256
    0bjkba9z93h2sf9n40dvmw1p6nq2p3d5zw9w3zw9k1crn7a601sv URL
    http://beta.quicklisp.org/archive/cl-dbi/2018-04-30/cl-dbi-20180430-git.tgz
    MD5 1bc845e8738c4987342cb0f56200ba50 NAME dbd-mysql FILENAME dbd-mysql DEPS
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
    VERSION cl-dbi-20180430-git SIBLINGS
    (cl-dbi dbd-postgres dbd-sqlite3 dbi-test dbi) PARASITES NIL) */
