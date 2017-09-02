args @ { fetchurl, ... }:
rec {
  baseName = ''local-time'';
  version = ''20170725-git'';

  description = ''A library for manipulating dates and times, based on a paper by Erik Naggum'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-fad" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/local-time/2017-07-25/local-time-20170725-git.tgz'';
    sha256 = ''05axwla93m5jml9lw6ljwzjhcl8pshfzxyqkvyj1w5l9klh569p9'';
  };

  packageName = "local-time";

  asdFilesToKeep = ["local-time.asd"];
  overrides = x: x;
}
/* (SYSTEM local-time DESCRIPTION
    A library for manipulating dates and times, based on a paper by Erik Naggum
    SHA256 05axwla93m5jml9lw6ljwzjhcl8pshfzxyqkvyj1w5l9klh569p9 URL
    http://beta.quicklisp.org/archive/local-time/2017-07-25/local-time-20170725-git.tgz
    MD5 77a79ed1036bc3547f5174f2256c8e93 NAME local-time FILENAME local-time
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-fad FILENAME cl-fad))
    DEPENDENCIES (alexandria bordeaux-threads cl-fad) VERSION 20170725-git
    SIBLINGS (cl-postgres+local-time local-time.test) PARASITES NIL) */
