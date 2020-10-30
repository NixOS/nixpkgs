args @ { fetchurl, ... }:
rec {
  baseName = ''postmodern'';
  version = ''20201016-git'';

  parasites = [ "postmodern/tests" ];

  description = ''PostgreSQL programming API'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-base64" args."cl-postgres" args."cl-postgres_slash_tests" args."cl-ppcre" args."cl-unicode" args."closer-mop" args."fiveam" args."flexi-streams" args."global-vars" args."ironclad" args."md5" args."s-sql" args."s-sql_slash_tests" args."simple-date" args."simple-date_slash_postgres-glue" args."split-sequence" args."uax-15" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2020-10-16/postmodern-20201016-git.tgz'';
    sha256 = ''1svaiksbqcaq8sh7q6sj9kzazdfl360zqr2nzhwbgy4xnaj4vf3n'';
  };

  packageName = "postmodern";

  asdFilesToKeep = ["postmodern.asd"];
  overrides = x: x;
}
/* (SYSTEM postmodern DESCRIPTION PostgreSQL programming API SHA256
    1svaiksbqcaq8sh7q6sj9kzazdfl360zqr2nzhwbgy4xnaj4vf3n URL
    http://beta.quicklisp.org/archive/postmodern/2020-10-16/postmodern-20201016-git.tgz
    MD5 f61e827d7e7ba023f6fbc7c2667de4c8 NAME postmodern FILENAME postmodern
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-postgres FILENAME cl-postgres)
     (NAME cl-postgres/tests FILENAME cl-postgres_slash_tests)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-unicode FILENAME cl-unicode)
     (NAME closer-mop FILENAME closer-mop) (NAME fiveam FILENAME fiveam)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME global-vars FILENAME global-vars) (NAME ironclad FILENAME ironclad)
     (NAME md5 FILENAME md5) (NAME s-sql FILENAME s-sql)
     (NAME s-sql/tests FILENAME s-sql_slash_tests)
     (NAME simple-date FILENAME simple-date)
     (NAME simple-date/postgres-glue FILENAME simple-date_slash_postgres-glue)
     (NAME split-sequence FILENAME split-sequence)
     (NAME uax-15 FILENAME uax-15) (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-base64 cl-postgres cl-postgres/tests
     cl-ppcre cl-unicode closer-mop fiveam flexi-streams global-vars ironclad
     md5 s-sql s-sql/tests simple-date simple-date/postgres-glue split-sequence
     uax-15 usocket)
    VERSION 20201016-git SIBLINGS (cl-postgres s-sql simple-date) PARASITES
    (postmodern/tests)) */
