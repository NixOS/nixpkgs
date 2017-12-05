args @ { fetchurl, ... }:
rec {
  baseName = ''s-sql'';
  version = ''postmodern-20170403-git'';

  description = '''';

  deps = [ args."cl-postgres" args."md5" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz'';
    sha256 = ''1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p'';
  };

  packageName = "s-sql";

  asdFilesToKeep = ["s-sql.asd"];
  overrides = x: x;
}
/* (SYSTEM s-sql DESCRIPTION NIL SHA256
    1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p URL
    http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz
    MD5 7a4145a0a5ff5bcb7a4bf29b5c2915d2 NAME s-sql FILENAME s-sql DEPS
    ((NAME cl-postgres FILENAME cl-postgres) (NAME md5 FILENAME md5))
    DEPENDENCIES (cl-postgres md5) VERSION postmodern-20170403-git SIBLINGS
    (cl-postgres postmodern simple-date) PARASITES NIL) */
