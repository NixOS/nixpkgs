args @ { fetchurl, ... }:
rec {
  baseName = ''cl-postgres'';
  version = ''postmodern-20180131-git'';

  parasites = [ "cl-postgres/simple-date-tests" "cl-postgres/tests" ];

  description = ''Low-level client library for PostgreSQL'';

  deps = [ args."fiveam" args."md5" args."simple-date_slash_postgres-glue" args."split-sequence" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2018-01-31/postmodern-20180131-git.tgz'';
    sha256 = ''0mz5pm759py1iscfn44c00dal2fijkyp5479fpx9l6i7wrdx2mki'';
  };

  packageName = "cl-postgres";

  asdFilesToKeep = ["cl-postgres.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-postgres DESCRIPTION Low-level client library for PostgreSQL
    SHA256 0mz5pm759py1iscfn44c00dal2fijkyp5479fpx9l6i7wrdx2mki URL
    http://beta.quicklisp.org/archive/postmodern/2018-01-31/postmodern-20180131-git.tgz
    MD5 a3b7bf25eb342cd49fe144fcd7ddcb16 NAME cl-postgres FILENAME cl-postgres
    DEPS
    ((NAME fiveam FILENAME fiveam) (NAME md5 FILENAME md5)
     (NAME simple-date/postgres-glue FILENAME simple-date_slash_postgres-glue)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES (fiveam md5 simple-date/postgres-glue split-sequence usocket)
    VERSION postmodern-20180131-git SIBLINGS (postmodern s-sql simple-date)
    PARASITES (cl-postgres/simple-date-tests cl-postgres/tests)) */
