args @ { fetchurl, ... }:
rec {
  baseName = ''cl-postgres'';
  version = ''postmodern-20170403-git'';

  parasites = [ "cl-postgres-tests" ];

  description = ''Low-level client library for PostgreSQL'';

  deps = [ args."fiveam" args."md5" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz'';
    sha256 = ''1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p'';
  };

  packageName = "cl-postgres";

  asdFilesToKeep = ["cl-postgres.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-postgres DESCRIPTION Low-level client library for PostgreSQL
    SHA256 1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p URL
    http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz
    MD5 7a4145a0a5ff5bcb7a4bf29b5c2915d2 NAME cl-postgres FILENAME cl-postgres
    DEPS ((NAME fiveam FILENAME fiveam) (NAME md5 FILENAME md5)) DEPENDENCIES
    (fiveam md5) VERSION postmodern-20170403-git SIBLINGS
    (postmodern s-sql simple-date) PARASITES (cl-postgres-tests)) */
