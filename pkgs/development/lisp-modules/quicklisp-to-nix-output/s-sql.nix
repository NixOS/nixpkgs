/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "s-sql";
  version = "postmodern-20210411-git";

  parasites = [ "s-sql/tests" ];

  description = "Lispy DSL for SQL";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-base64" args."cl-postgres" args."cl-postgres_slash_tests" args."cl-ppcre" args."cl-unicode" args."closer-mop" args."fiveam" args."global-vars" args."ironclad" args."md5" args."postmodern" args."split-sequence" args."uax-15" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/postmodern/2021-04-11/postmodern-20210411-git.tgz";
    sha256 = "0q8izkkddmqq5sw55chkx6jrycawgchaknik5i84vynv50zirsbw";
  };

  packageName = "s-sql";

  asdFilesToKeep = ["s-sql.asd"];
  overrides = x: x;
}
/* (SYSTEM s-sql DESCRIPTION Lispy DSL for SQL SHA256
    0q8izkkddmqq5sw55chkx6jrycawgchaknik5i84vynv50zirsbw URL
    http://beta.quicklisp.org/archive/postmodern/2021-04-11/postmodern-20210411-git.tgz
    MD5 8a75a05ba9e371f672f2620d40724cb2 NAME s-sql FILENAME s-sql DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-postgres FILENAME cl-postgres)
     (NAME cl-postgres/tests FILENAME cl-postgres_slash_tests)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-unicode FILENAME cl-unicode)
     (NAME closer-mop FILENAME closer-mop) (NAME fiveam FILENAME fiveam)
     (NAME global-vars FILENAME global-vars) (NAME ironclad FILENAME ironclad)
     (NAME md5 FILENAME md5) (NAME postmodern FILENAME postmodern)
     (NAME split-sequence FILENAME split-sequence)
     (NAME uax-15 FILENAME uax-15) (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-base64 cl-postgres cl-postgres/tests
     cl-ppcre cl-unicode closer-mop fiveam global-vars ironclad md5 postmodern
     split-sequence uax-15 usocket)
    VERSION postmodern-20210411-git SIBLINGS
    (cl-postgres postmodern simple-date) PARASITES (s-sql/tests)) */
