args @ { fetchurl, ... }:
rec {
  baseName = ''cl-postgres'';
  version = ''postmodern-20180831-git'';

  parasites = [ "cl-postgres/tests" ];

  description = ''Low-level client library for PostgreSQL'';

  deps = [ args."fiveam" args."md5" args."split-sequence" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2018-08-31/postmodern-20180831-git.tgz'';
    sha256 = ''062xhy6aadzgmwpz8h0n7884yv5m4nwqmxrc75m3c60k1lmccpwx'';
  };

  packageName = "cl-postgres";

  asdFilesToKeep = ["cl-postgres.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-postgres DESCRIPTION Low-level client library for PostgreSQL
    SHA256 062xhy6aadzgmwpz8h0n7884yv5m4nwqmxrc75m3c60k1lmccpwx URL
    http://beta.quicklisp.org/archive/postmodern/2018-08-31/postmodern-20180831-git.tgz
    MD5 78c3e998cff7305db5e4b4e90b9bbee6 NAME cl-postgres FILENAME cl-postgres
    DEPS
    ((NAME fiveam FILENAME fiveam) (NAME md5 FILENAME md5)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES (fiveam md5 split-sequence usocket) VERSION
    postmodern-20180831-git SIBLINGS (postmodern s-sql simple-date) PARASITES
    (cl-postgres/tests)) */
