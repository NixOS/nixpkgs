args @ { fetchurl, ... }:
{
  baseName = ''s-sql'';
  version = ''postmodern-20180430-git'';

  parasites = [ "s-sql/tests" ];

  description = '''';

  deps = [ args."bordeaux-threads" args."cl-postgres" args."cl-postgres_slash_tests" args."closer-mop" args."fiveam" args."md5" args."postmodern" args."split-sequence" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2018-04-30/postmodern-20180430-git.tgz'';
    sha256 = ''0b6w8f5ihbk036v1fclyskns615xhnib9q3cjn0ql6r6sk3nca7f'';
  };

  packageName = "s-sql";

  asdFilesToKeep = ["s-sql.asd"];
  overrides = x: x;
}
/* (SYSTEM s-sql DESCRIPTION NIL SHA256
    0b6w8f5ihbk036v1fclyskns615xhnib9q3cjn0ql6r6sk3nca7f URL
    http://beta.quicklisp.org/archive/postmodern/2018-04-30/postmodern-20180430-git.tgz
    MD5 9ca2a4ccf4ea7dbcd14d69cb355a8214 NAME s-sql FILENAME s-sql DEPS
    ((NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-postgres FILENAME cl-postgres)
     (NAME cl-postgres/tests FILENAME cl-postgres_slash_tests)
     (NAME closer-mop FILENAME closer-mop) (NAME fiveam FILENAME fiveam)
     (NAME md5 FILENAME md5) (NAME postmodern FILENAME postmodern)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (bordeaux-threads cl-postgres cl-postgres/tests closer-mop fiveam md5
     postmodern split-sequence usocket)
    VERSION postmodern-20180430-git SIBLINGS
    (cl-postgres postmodern simple-date) PARASITES (s-sql/tests)) */
