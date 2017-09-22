args @ { fetchurl, ... }:
rec {
  baseName = ''postmodern'';
  version = ''20170403-git'';

  parasites = [ "postmodern-tests" ];

  description = ''PostgreSQL programming API'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-postgres" args."cl-postgres-tests" args."closer-mop" args."fiveam" args."md5" args."s-sql" args."simple-date" args."simple-date-postgres-glue" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz'';
    sha256 = ''1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p'';
  };

  packageName = "postmodern";

  asdFilesToKeep = ["postmodern.asd"];
  overrides = x: x;
}
/* (SYSTEM postmodern DESCRIPTION PostgreSQL programming API SHA256
    1pklmp0y0falrmbxll79drrcrlgslasavdym5r45m8kkzi1zpv9p URL
    http://beta.quicklisp.org/archive/postmodern/2017-04-03/postmodern-20170403-git.tgz
    MD5 7a4145a0a5ff5bcb7a4bf29b5c2915d2 NAME postmodern FILENAME postmodern
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-postgres FILENAME cl-postgres)
     (NAME cl-postgres-tests FILENAME cl-postgres-tests)
     (NAME closer-mop FILENAME closer-mop) (NAME fiveam FILENAME fiveam)
     (NAME md5 FILENAME md5) (NAME s-sql FILENAME s-sql)
     (NAME simple-date FILENAME simple-date)
     (NAME simple-date-postgres-glue FILENAME simple-date-postgres-glue))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-postgres cl-postgres-tests closer-mop
     fiveam md5 s-sql simple-date simple-date-postgres-glue)
    VERSION 20170403-git SIBLINGS (cl-postgres s-sql simple-date) PARASITES
    (postmodern-tests)) */
