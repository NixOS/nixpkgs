/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-dbi";
  version = "20210228-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."bordeaux-threads" args."closer-mop" args."dbi" args."split-sequence" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-dbi/2021-02-28/cl-dbi-20210228-git.tgz";
    sha256 = "0yfs7k6samv6q0n1bvscvcck7qg3c4g03qn7i81619q7g2f98jdk";
  };

  packageName = "cl-dbi";

  asdFilesToKeep = ["cl-dbi.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-dbi DESCRIPTION System lacks description SHA256
    0yfs7k6samv6q0n1bvscvcck7qg3c4g03qn7i81619q7g2f98jdk URL
    http://beta.quicklisp.org/archive/cl-dbi/2021-02-28/cl-dbi-20210228-git.tgz
    MD5 7cfb5ad172bc30906ae32ca620099a1f NAME cl-dbi FILENAME cl-dbi DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME closer-mop FILENAME closer-mop) (NAME dbi FILENAME dbi)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES (alexandria bordeaux-threads closer-mop dbi split-sequence)
    VERSION 20210228-git SIBLINGS
    (dbd-mysql dbd-postgres dbd-sqlite3 dbi-test dbi) PARASITES NIL) */
