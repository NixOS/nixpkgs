args @ { fetchurl, ... }:
rec {
  baseName = ''cl-postgres'';
  version = ''postmodern-20180430-git'';

  parasites = [ "cl-postgres/simple-date-tests" "cl-postgres/tests" ];

  description = ''Low-level client library for PostgreSQL'';

  deps = [ args."fiveam" args."md5" args."simple-date_slash_postgres-glue" args."split-sequence" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2018-04-30/postmodern-20180430-git.tgz'';
    sha256 = ''0b6w8f5ihbk036v1fclyskns615xhnib9q3cjn0ql6r6sk3nca7f'';
  };

  packageName = "cl-postgres";

  asdFilesToKeep = ["cl-postgres.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-postgres DESCRIPTION Low-level client library for PostgreSQL
    SHA256 0b6w8f5ihbk036v1fclyskns615xhnib9q3cjn0ql6r6sk3nca7f URL
    http://beta.quicklisp.org/archive/postmodern/2018-04-30/postmodern-20180430-git.tgz
    MD5 9ca2a4ccf4ea7dbcd14d69cb355a8214 NAME cl-postgres FILENAME cl-postgres
    DEPS
    ((NAME fiveam FILENAME fiveam) (NAME md5 FILENAME md5)
     (NAME simple-date/postgres-glue FILENAME simple-date_slash_postgres-glue)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES (fiveam md5 simple-date/postgres-glue split-sequence usocket)
    VERSION postmodern-20180430-git SIBLINGS (postmodern s-sql simple-date)
    PARASITES (cl-postgres/simple-date-tests cl-postgres/tests)) */
