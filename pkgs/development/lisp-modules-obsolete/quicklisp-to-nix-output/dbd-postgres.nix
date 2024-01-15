/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "dbd-postgres";
  version = "cl-dbi-20211020-git";

  description = "Database driver for PostgreSQL.";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-base64" args."cl-postgres" args."cl-ppcre" args."closer-mop" args."dbi" args."ironclad" args."md5" args."split-sequence" args."trivial-garbage" args."uax-15" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-dbi/2021-10-20/cl-dbi-20211020-git.tgz";
    sha256 = "1khvf4b2pa9wv8blcwb77byi5nyb8g8bnaq4ml20g674iwgvvvmr";
  };

  packageName = "dbd-postgres";

  asdFilesToKeep = ["dbd-postgres.asd"];
  overrides = x: x;
}
/* (SYSTEM dbd-postgres DESCRIPTION Database driver for PostgreSQL. SHA256
    1khvf4b2pa9wv8blcwb77byi5nyb8g8bnaq4ml20g674iwgvvvmr URL
    http://beta.quicklisp.org/archive/cl-dbi/2021-10-20/cl-dbi-20211020-git.tgz
    MD5 565a1f32b2d924ad59876afcdc5cf263 NAME dbd-postgres FILENAME
    dbd-postgres DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-postgres FILENAME cl-postgres) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closer-mop FILENAME closer-mop) (NAME dbi FILENAME dbi)
     (NAME ironclad FILENAME ironclad) (NAME md5 FILENAME md5)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME uax-15 FILENAME uax-15) (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-base64 cl-postgres cl-ppcre closer-mop dbi
     ironclad md5 split-sequence trivial-garbage uax-15 usocket)
    VERSION cl-dbi-20211020-git SIBLINGS
    (cl-dbi dbd-mysql dbd-sqlite3 dbi-test dbi) PARASITES NIL) */
