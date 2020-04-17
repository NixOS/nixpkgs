args @ { fetchurl, ... }:
rec {
  baseName = ''cl-postgres'';
  version = ''postmodern-20191227-git'';

  parasites = [ "cl-postgres/tests" ];

  description = ''Low-level client library for PostgreSQL'';

  deps = [ args."fiveam" args."md5" args."split-sequence" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2019-12-27/postmodern-20191227-git.tgz'';
    sha256 = ''1p44aphx7y0lh018pk2r9w006vinc5yrfrp1m9l9648p2jxiw1c4'';
  };

  packageName = "cl-postgres";

  asdFilesToKeep = ["cl-postgres.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-postgres DESCRIPTION Low-level client library for PostgreSQL
    SHA256 1p44aphx7y0lh018pk2r9w006vinc5yrfrp1m9l9648p2jxiw1c4 URL
    http://beta.quicklisp.org/archive/postmodern/2019-12-27/postmodern-20191227-git.tgz
    MD5 67b909de432e6414e7832eed18f9ad18 NAME cl-postgres FILENAME cl-postgres
    DEPS
    ((NAME fiveam FILENAME fiveam) (NAME md5 FILENAME md5)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES (fiveam md5 split-sequence usocket) VERSION
    postmodern-20191227-git SIBLINGS (postmodern s-sql simple-date) PARASITES
    (cl-postgres/tests)) */
