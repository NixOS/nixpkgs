/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-dbi";
  version = "20211020-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."bordeaux-threads" args."closer-mop" args."dbi" args."split-sequence" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-dbi/2021-10-20/cl-dbi-20211020-git.tgz";
    sha256 = "1khvf4b2pa9wv8blcwb77byi5nyb8g8bnaq4ml20g674iwgvvvmr";
  };

  packageName = "cl-dbi";

  asdFilesToKeep = ["cl-dbi.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-dbi DESCRIPTION System lacks description SHA256
    1khvf4b2pa9wv8blcwb77byi5nyb8g8bnaq4ml20g674iwgvvvmr URL
    http://beta.quicklisp.org/archive/cl-dbi/2021-10-20/cl-dbi-20211020-git.tgz
    MD5 565a1f32b2d924ad59876afcdc5cf263 NAME cl-dbi FILENAME cl-dbi DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME closer-mop FILENAME closer-mop) (NAME dbi FILENAME dbi)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES (alexandria bordeaux-threads closer-mop dbi split-sequence)
    VERSION 20211020-git SIBLINGS
    (dbd-mysql dbd-postgres dbd-sqlite3 dbi-test dbi) PARASITES NIL) */
