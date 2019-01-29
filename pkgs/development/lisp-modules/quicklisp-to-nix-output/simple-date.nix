args @ { fetchurl, ... }:
rec {
  baseName = ''simple-date'';
  version = ''postmodern-20180831-git'';

  parasites = [ "simple-date/postgres-glue" ];

  description = '''';

  deps = [ args."cl-postgres" args."md5" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2018-08-31/postmodern-20180831-git.tgz'';
    sha256 = ''062xhy6aadzgmwpz8h0n7884yv5m4nwqmxrc75m3c60k1lmccpwx'';
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION NIL SHA256
    062xhy6aadzgmwpz8h0n7884yv5m4nwqmxrc75m3c60k1lmccpwx URL
    http://beta.quicklisp.org/archive/postmodern/2018-08-31/postmodern-20180831-git.tgz
    MD5 78c3e998cff7305db5e4b4e90b9bbee6 NAME simple-date FILENAME simple-date
    DEPS
    ((NAME cl-postgres FILENAME cl-postgres) (NAME md5 FILENAME md5)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES (cl-postgres md5 usocket) VERSION postmodern-20180831-git
    SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/postgres-glue)) */
