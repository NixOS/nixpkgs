args @ { fetchurl, ... }:
rec {
  baseName = ''simple-date'';
  version = ''postmodern-20180430-git'';

  parasites = [ "simple-date/postgres-glue" "simple-date/tests" ];

  description = '''';

  deps = [ args."cl-postgres" args."fiveam" args."md5" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2018-04-30/postmodern-20180430-git.tgz'';
    sha256 = ''0b6w8f5ihbk036v1fclyskns615xhnib9q3cjn0ql6r6sk3nca7f'';
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION NIL SHA256
    0b6w8f5ihbk036v1fclyskns615xhnib9q3cjn0ql6r6sk3nca7f URL
    http://beta.quicklisp.org/archive/postmodern/2018-04-30/postmodern-20180430-git.tgz
    MD5 9ca2a4ccf4ea7dbcd14d69cb355a8214 NAME simple-date FILENAME simple-date
    DEPS
    ((NAME cl-postgres FILENAME cl-postgres) (NAME fiveam FILENAME fiveam)
     (NAME md5 FILENAME md5) (NAME usocket FILENAME usocket))
    DEPENDENCIES (cl-postgres fiveam md5 usocket) VERSION
    postmodern-20180430-git SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/postgres-glue simple-date/tests)) */
