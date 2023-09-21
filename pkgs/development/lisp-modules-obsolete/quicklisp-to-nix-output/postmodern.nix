/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "postmodern";
  version = "20211209-git";

  parasites = [ "postmodern/tests" ];

  description = "PostgreSQL programming API";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-base64" args."cl-postgres" args."cl-postgres_plus_local-time" args."cl-postgres_slash_tests" args."cl-ppcre" args."closer-mop" args."fiveam" args."global-vars" args."ironclad" args."local-time" args."md5" args."s-sql" args."s-sql_slash_tests" args."simple-date" args."simple-date_slash_postgres-glue" args."split-sequence" args."uax-15" args."uiop" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/postmodern/2021-12-09/postmodern-20211209-git.tgz";
    sha256 = "1qcbg31mz5r7ibmq2y7r3vqvdwpznxvwdnwd94hfil7pg4j119d6";
  };

  packageName = "postmodern";

  asdFilesToKeep = ["postmodern.asd"];
  overrides = x: x;
}
/* (SYSTEM postmodern DESCRIPTION PostgreSQL programming API SHA256
    1qcbg31mz5r7ibmq2y7r3vqvdwpznxvwdnwd94hfil7pg4j119d6 URL
    http://beta.quicklisp.org/archive/postmodern/2021-12-09/postmodern-20211209-git.tgz
    MD5 6d14c4b5fec085594dc66d520174e0e6 NAME postmodern FILENAME postmodern
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-postgres FILENAME cl-postgres)
     (NAME cl-postgres+local-time FILENAME cl-postgres_plus_local-time)
     (NAME cl-postgres/tests FILENAME cl-postgres_slash_tests)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME closer-mop FILENAME closer-mop)
     (NAME fiveam FILENAME fiveam) (NAME global-vars FILENAME global-vars)
     (NAME ironclad FILENAME ironclad) (NAME local-time FILENAME local-time)
     (NAME md5 FILENAME md5) (NAME s-sql FILENAME s-sql)
     (NAME s-sql/tests FILENAME s-sql_slash_tests)
     (NAME simple-date FILENAME simple-date)
     (NAME simple-date/postgres-glue FILENAME simple-date_slash_postgres-glue)
     (NAME split-sequence FILENAME split-sequence)
     (NAME uax-15 FILENAME uax-15) (NAME uiop FILENAME uiop)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-base64 cl-postgres cl-postgres+local-time
     cl-postgres/tests cl-ppcre closer-mop fiveam global-vars ironclad
     local-time md5 s-sql s-sql/tests simple-date simple-date/postgres-glue
     split-sequence uax-15 uiop usocket)
    VERSION 20211209-git SIBLINGS (cl-postgres s-sql simple-date) PARASITES
    (postmodern/tests)) */
