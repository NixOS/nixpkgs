args @ { fetchurl, ... }:
rec {
  baseName = ''simple-date'';
  version = ''postmodern-20191227-git'';

  parasites = [ "simple-date/postgres-glue" "simple-date/tests" ];

  description = ''System lacks description'';

  deps = [ args."cl-postgres" args."fiveam" args."md5" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2019-12-27/postmodern-20191227-git.tgz'';
    sha256 = ''1p44aphx7y0lh018pk2r9w006vinc5yrfrp1m9l9648p2jxiw1c4'';
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION System lacks description SHA256
    1p44aphx7y0lh018pk2r9w006vinc5yrfrp1m9l9648p2jxiw1c4 URL
    http://beta.quicklisp.org/archive/postmodern/2019-12-27/postmodern-20191227-git.tgz
    MD5 67b909de432e6414e7832eed18f9ad18 NAME simple-date FILENAME simple-date
    DEPS
    ((NAME cl-postgres FILENAME cl-postgres) (NAME fiveam FILENAME fiveam)
     (NAME md5 FILENAME md5) (NAME usocket FILENAME usocket))
    DEPENDENCIES (cl-postgres fiveam md5 usocket) VERSION
    postmodern-20191227-git SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/postgres-glue simple-date/tests)) */
