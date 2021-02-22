args @ { fetchurl, ... }:
rec {
  baseName = "dbi";
  version = "cl-20200610-git";

  parasites = [ "dbi/test" ];

  description = "Database independent interface for Common Lisp";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-mysql" args."cl-postgres" args."closer-mop" args."dbd-mysql" args."dbd-postgres" args."dbd-sqlite3" args."dbi-test" args."rove" args."split-sequence" args."sqlite" args."trivial-garbage" args."trivial-types" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-dbi/2020-06-10/cl-dbi-20200610-git.tgz";
    sha256 = "1d7hwywcqzqwmr5b42c0mmjq3v3xxd4cwb4fn5k1wd7j6pr0bkas";
  };

  packageName = "dbi";

  asdFilesToKeep = ["dbi.asd"];
  overrides = x: x;
}
/* (SYSTEM dbi DESCRIPTION Database independent interface for Common Lisp
    SHA256 1d7hwywcqzqwmr5b42c0mmjq3v3xxd4cwb4fn5k1wd7j6pr0bkas URL
    http://beta.quicklisp.org/archive/cl-dbi/2020-06-10/cl-dbi-20200610-git.tgz
    MD5 2caeb911b23327e054986211d6bfea55 NAME dbi FILENAME dbi DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-mysql FILENAME cl-mysql) (NAME cl-postgres FILENAME cl-postgres)
     (NAME closer-mop FILENAME closer-mop) (NAME dbd-mysql FILENAME dbd-mysql)
     (NAME dbd-postgres FILENAME dbd-postgres)
     (NAME dbd-sqlite3 FILENAME dbd-sqlite3) (NAME dbi-test FILENAME dbi-test)
     (NAME rove FILENAME rove) (NAME split-sequence FILENAME split-sequence)
     (NAME sqlite FILENAME sqlite)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-mysql cl-postgres closer-mop dbd-mysql
     dbd-postgres dbd-sqlite3 dbi-test rove split-sequence sqlite
     trivial-garbage trivial-types)
    VERSION cl-20200610-git SIBLINGS
    (cl-dbi dbd-mysql dbd-postgres dbd-sqlite3 dbi-test) PARASITES (dbi/test)) */
