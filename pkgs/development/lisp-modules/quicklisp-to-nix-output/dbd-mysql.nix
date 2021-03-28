/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "dbd-mysql";
  version = "cl-dbi-20210228-git";

  description = "Database driver for MySQL.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl-mysql" args."closer-mop" args."dbi" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-dbi/2021-02-28/cl-dbi-20210228-git.tgz";
    sha256 = "0yfs7k6samv6q0n1bvscvcck7qg3c4g03qn7i81619q7g2f98jdk";
  };

  packageName = "dbd-mysql";

  asdFilesToKeep = ["dbd-mysql.asd"];
  overrides = x: x;
}
/* (SYSTEM dbd-mysql DESCRIPTION Database driver for MySQL. SHA256
    0yfs7k6samv6q0n1bvscvcck7qg3c4g03qn7i81619q7g2f98jdk URL
    http://beta.quicklisp.org/archive/cl-dbi/2021-02-28/cl-dbi-20210228-git.tgz
    MD5 7cfb5ad172bc30906ae32ca620099a1f NAME dbd-mysql FILENAME dbd-mysql DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cl-mysql FILENAME cl-mysql)
     (NAME closer-mop FILENAME closer-mop) (NAME dbi FILENAME dbi)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cl-mysql closer-mop dbi
     split-sequence trivial-features)
    VERSION cl-dbi-20210228-git SIBLINGS
    (cl-dbi dbd-postgres dbd-sqlite3 dbi-test dbi) PARASITES NIL) */
