args @ { fetchurl, ... }:
rec {
  baseName = ''postmodern'';
  version = ''20180131-git'';

  parasites = [ "postmodern/tests" ];

  description = ''PostgreSQL programming API'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-postgres" args."cl-postgres_slash_tests" args."closer-mop" args."fiveam" args."md5" args."s-sql" args."simple-date" args."simple-date_slash_postgres-glue" args."split-sequence" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2018-01-31/postmodern-20180131-git.tgz'';
    sha256 = ''0mz5pm759py1iscfn44c00dal2fijkyp5479fpx9l6i7wrdx2mki'';
  };

  packageName = "postmodern";

  asdFilesToKeep = ["postmodern.asd"];
  overrides = x: x;
}
/* (SYSTEM postmodern DESCRIPTION PostgreSQL programming API SHA256
    0mz5pm759py1iscfn44c00dal2fijkyp5479fpx9l6i7wrdx2mki URL
    http://beta.quicklisp.org/archive/postmodern/2018-01-31/postmodern-20180131-git.tgz
    MD5 a3b7bf25eb342cd49fe144fcd7ddcb16 NAME postmodern FILENAME postmodern
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-postgres FILENAME cl-postgres)
     (NAME cl-postgres/tests FILENAME cl-postgres_slash_tests)
     (NAME closer-mop FILENAME closer-mop) (NAME fiveam FILENAME fiveam)
     (NAME md5 FILENAME md5) (NAME s-sql FILENAME s-sql)
     (NAME simple-date FILENAME simple-date)
     (NAME simple-date/postgres-glue FILENAME simple-date_slash_postgres-glue)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-postgres cl-postgres/tests closer-mop
     fiveam md5 s-sql simple-date simple-date/postgres-glue split-sequence
     usocket)
    VERSION 20180131-git SIBLINGS (cl-postgres s-sql simple-date) PARASITES
    (postmodern/tests)) */
