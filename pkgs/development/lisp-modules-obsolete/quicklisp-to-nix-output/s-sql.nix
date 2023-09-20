/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "s-sql";
  version = "postmodern-20211209-git";

  parasites = [ "s-sql/tests" ];

  description = "Lispy DSL for SQL";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-base64" args."cl-postgres" args."cl-postgres_slash_tests" args."cl-ppcre" args."closer-mop" args."fiveam" args."global-vars" args."ironclad" args."md5" args."postmodern" args."split-sequence" args."uax-15" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/postmodern/2021-12-09/postmodern-20211209-git.tgz";
    sha256 = "1qcbg31mz5r7ibmq2y7r3vqvdwpznxvwdnwd94hfil7pg4j119d6";
  };

  packageName = "s-sql";

  asdFilesToKeep = ["s-sql.asd"];
  overrides = x: x;
}
/* (SYSTEM s-sql DESCRIPTION Lispy DSL for SQL SHA256
    1qcbg31mz5r7ibmq2y7r3vqvdwpznxvwdnwd94hfil7pg4j119d6 URL
    http://beta.quicklisp.org/archive/postmodern/2021-12-09/postmodern-20211209-git.tgz
    MD5 6d14c4b5fec085594dc66d520174e0e6 NAME s-sql FILENAME s-sql DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-postgres FILENAME cl-postgres)
     (NAME cl-postgres/tests FILENAME cl-postgres_slash_tests)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME closer-mop FILENAME closer-mop)
     (NAME fiveam FILENAME fiveam) (NAME global-vars FILENAME global-vars)
     (NAME ironclad FILENAME ironclad) (NAME md5 FILENAME md5)
     (NAME postmodern FILENAME postmodern)
     (NAME split-sequence FILENAME split-sequence)
     (NAME uax-15 FILENAME uax-15) (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-base64 cl-postgres cl-postgres/tests
     cl-ppcre closer-mop fiveam global-vars ironclad md5 postmodern
     split-sequence uax-15 usocket)
    VERSION postmodern-20211209-git SIBLINGS
    (cl-postgres postmodern simple-date) PARASITES (s-sql/tests)) */
