args @ { fetchurl, ... }:
rec {
  baseName = ''simple-date'';
  version = ''postmodern-20170403-git'';

  parasites = [ "simple-date-postgres-glue" "simple-date-tests" ];

  description = '''';

  deps = [ args."cl-postgres" args."fiveam" args."md5" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz'';
    sha256 = ''1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p'';
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION NIL SHA256
    1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p URL
    http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz
    MD5 7a4145a0a5ff5bcb7a4bf29b5c2915d2 NAME simple-date FILENAME simple-date
    DEPS
    ((NAME cl-postgres FILENAME cl-postgres) (NAME fiveam FILENAME fiveam)
     (NAME md5 FILENAME md5))
    DEPENDENCIES (cl-postgres fiveam md5) VERSION postmodern-20170403-git
    SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date-postgres-glue simple-date-tests)) */
