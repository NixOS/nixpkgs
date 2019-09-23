args @ { fetchurl, ... }:
{
  baseName = ''cl-postgres'';
  version = ''postmodern-20190521-git'';

  parasites = [ "cl-postgres/simple-date-tests" "cl-postgres/tests" ];

  description = ''Low-level client library for PostgreSQL'';

  deps = [ args."fiveam" args."md5" args."simple-date_slash_postgres-glue" args."split-sequence" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2019-05-21/postmodern-20190521-git.tgz'';
    sha256 = ''1vphrizbhbs3r5rq4b8dh4149bz11h5xxilragwf4l2i619k3cp5'';
  };

  packageName = "cl-postgres";

  asdFilesToKeep = ["cl-postgres.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-postgres DESCRIPTION Low-level client library for PostgreSQL
    SHA256 1vphrizbhbs3r5rq4b8dh4149bz11h5xxilragwf4l2i619k3cp5 URL
    http://beta.quicklisp.org/archive/postmodern/2019-05-21/postmodern-20190521-git.tgz
    MD5 102567f386757cd52aca500c0c348d90 NAME cl-postgres FILENAME cl-postgres
    DEPS
    ((NAME fiveam FILENAME fiveam) (NAME md5 FILENAME md5)
     (NAME simple-date/postgres-glue FILENAME simple-date_slash_postgres-glue)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES (fiveam md5 simple-date/postgres-glue split-sequence usocket)
    VERSION postmodern-20190521-git SIBLINGS (postmodern s-sql simple-date)
    PARASITES (cl-postgres/simple-date-tests cl-postgres/tests)) */
