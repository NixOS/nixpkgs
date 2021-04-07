/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "postmodern";
  version = "20210124-git";

  parasites = [ "postmodern/tests" ];

  description = "PostgreSQL programming API";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-base64" args."cl-postgres" args."cl-postgres_plus_local-time" args."cl-postgres_slash_tests" args."cl-ppcre" args."cl-unicode" args."closer-mop" args."fiveam" args."flexi-streams" args."global-vars" args."ironclad" args."local-time" args."md5" args."s-sql" args."s-sql_slash_tests" args."simple-date" args."simple-date_slash_postgres-glue" args."split-sequence" args."uax-15" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/postmodern/2021-01-24/postmodern-20210124-git.tgz";
    sha256 = "1fl103fga5iq2gf1p15xvbrmmjrcv2bbi3lz1zv32j6smy5aymhc";
  };

  packageName = "postmodern";

  asdFilesToKeep = ["postmodern.asd"];
  overrides = x: x;
}
/* (SYSTEM postmodern DESCRIPTION PostgreSQL programming API SHA256
    1fl103fga5iq2gf1p15xvbrmmjrcv2bbi3lz1zv32j6smy5aymhc URL
    http://beta.quicklisp.org/archive/postmodern/2021-01-24/postmodern-20210124-git.tgz
    MD5 05c2c5f4d2354a5fa69a32b7b96f8ff8 NAME postmodern FILENAME postmodern
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-postgres FILENAME cl-postgres)
     (NAME cl-postgres+local-time FILENAME cl-postgres_plus_local-time)
     (NAME cl-postgres/tests FILENAME cl-postgres_slash_tests)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-unicode FILENAME cl-unicode)
     (NAME closer-mop FILENAME closer-mop) (NAME fiveam FILENAME fiveam)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME global-vars FILENAME global-vars) (NAME ironclad FILENAME ironclad)
     (NAME local-time FILENAME local-time) (NAME md5 FILENAME md5)
     (NAME s-sql FILENAME s-sql) (NAME s-sql/tests FILENAME s-sql_slash_tests)
     (NAME simple-date FILENAME simple-date)
     (NAME simple-date/postgres-glue FILENAME simple-date_slash_postgres-glue)
     (NAME split-sequence FILENAME split-sequence)
     (NAME uax-15 FILENAME uax-15) (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-base64 cl-postgres cl-postgres+local-time
     cl-postgres/tests cl-ppcre cl-unicode closer-mop fiveam flexi-streams
     global-vars ironclad local-time md5 s-sql s-sql/tests simple-date
     simple-date/postgres-glue split-sequence uax-15 usocket)
    VERSION 20210124-git SIBLINGS (cl-postgres s-sql simple-date) PARASITES
    (postmodern/tests)) */
