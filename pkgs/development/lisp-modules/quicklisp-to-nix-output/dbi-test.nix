/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "dbi-test";
  version = "cl-dbi-20211020-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."bordeaux-threads" args."closer-mop" args."dbi" args."dissect" args."rove" args."split-sequence" args."trivial-gray-streams" args."trivial-types" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-dbi/2021-10-20/cl-dbi-20211020-git.tgz";
    sha256 = "1khvf4b2pa9wv8blcwb77byi5nyb8g8bnaq4ml20g674iwgvvvmr";
  };

  packageName = "dbi-test";

  asdFilesToKeep = ["dbi-test.asd"];
  overrides = x: x;
}
/* (SYSTEM dbi-test DESCRIPTION System lacks description SHA256
    1khvf4b2pa9wv8blcwb77byi5nyb8g8bnaq4ml20g674iwgvvvmr URL
    http://beta.quicklisp.org/archive/cl-dbi/2021-10-20/cl-dbi-20211020-git.tgz
    MD5 565a1f32b2d924ad59876afcdc5cf263 NAME dbi-test FILENAME dbi-test DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME closer-mop FILENAME closer-mop) (NAME dbi FILENAME dbi)
     (NAME dissect FILENAME dissect) (NAME rove FILENAME rove)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES
    (alexandria bordeaux-threads closer-mop dbi dissect rove split-sequence
     trivial-gray-streams trivial-types)
    VERSION cl-dbi-20211020-git SIBLINGS
    (cl-dbi dbd-mysql dbd-postgres dbd-sqlite3 dbi) PARASITES NIL) */
