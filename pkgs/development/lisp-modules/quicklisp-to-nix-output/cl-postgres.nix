args @ { fetchurl, ... }:
rec {
  baseName = ''cl-postgres'';
  version = ''postmodern-20190107-git'';

  parasites = [ "cl-postgres/simple-date-tests" "cl-postgres/tests" ];

  description = ''Low-level client library for PostgreSQL'';

  deps = [ args."fiveam" args."md5" args."simple-date_slash_postgres-glue" args."split-sequence" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2019-01-07/postmodern-20190107-git.tgz'';
    sha256 = ''030p5kp593p4z7p3k0828dlayglw2si3q187z1fafgpvspp42sd5'';
  };

  packageName = "cl-postgres";

  asdFilesToKeep = ["cl-postgres.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-postgres DESCRIPTION Low-level client library for PostgreSQL
    SHA256 030p5kp593p4z7p3k0828dlayglw2si3q187z1fafgpvspp42sd5 URL
    http://beta.quicklisp.org/archive/postmodern/2019-01-07/postmodern-20190107-git.tgz
    MD5 3f6f78c4fb0f5a8bb9f13247f1f3d6eb NAME cl-postgres FILENAME cl-postgres
    DEPS
    ((NAME fiveam FILENAME fiveam) (NAME md5 FILENAME md5)
     (NAME simple-date/postgres-glue FILENAME simple-date_slash_postgres-glue)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES (fiveam md5 simple-date/postgres-glue split-sequence usocket)
    VERSION postmodern-20190107-git SIBLINGS (postmodern s-sql simple-date)
    PARASITES (cl-postgres/simple-date-tests cl-postgres/tests)) */
