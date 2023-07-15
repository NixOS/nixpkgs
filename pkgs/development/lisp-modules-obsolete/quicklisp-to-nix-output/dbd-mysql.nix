/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "dbd-mysql";
  version = "cl-dbi-20211020-git";

  description = "Database driver for MySQL.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl-mysql" args."closer-mop" args."dbi" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-dbi/2021-10-20/cl-dbi-20211020-git.tgz";
    sha256 = "1khvf4b2pa9wv8blcwb77byi5nyb8g8bnaq4ml20g674iwgvvvmr";
  };

  packageName = "dbd-mysql";

  asdFilesToKeep = ["dbd-mysql.asd"];
  overrides = x: x;
}
/* (SYSTEM dbd-mysql DESCRIPTION Database driver for MySQL. SHA256
    1khvf4b2pa9wv8blcwb77byi5nyb8g8bnaq4ml20g674iwgvvvmr URL
    http://beta.quicklisp.org/archive/cl-dbi/2021-10-20/cl-dbi-20211020-git.tgz
    MD5 565a1f32b2d924ad59876afcdc5cf263 NAME dbd-mysql FILENAME dbd-mysql DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cl-mysql FILENAME cl-mysql)
     (NAME closer-mop FILENAME closer-mop) (NAME dbi FILENAME dbi)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cl-mysql closer-mop dbi
     split-sequence trivial-features)
    VERSION cl-dbi-20211020-git SIBLINGS
    (cl-dbi dbd-postgres dbd-sqlite3 dbi-test dbi) PARASITES NIL) */
