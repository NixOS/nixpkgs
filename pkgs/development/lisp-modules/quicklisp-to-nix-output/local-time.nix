args @ { fetchurl, ... }:
rec {
  baseName = ''local-time'';
  version = ''20181210-git'';

  parasites = [ "local-time/test" ];

  description = ''A library for manipulating dates and times, based on a paper by Erik Naggum'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-fad" args."stefil" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/local-time/2018-12-10/local-time-20181210-git.tgz'';
    sha256 = ''0m17mjql9f2glr9f2cg5d2dk5gi2xjjqxih18dx71jpbd71m6q4s'';
  };

  packageName = "local-time";

  asdFilesToKeep = ["local-time.asd"];
  overrides = x: x;
}
/* (SYSTEM local-time DESCRIPTION
    A library for manipulating dates and times, based on a paper by Erik Naggum
    SHA256 0m17mjql9f2glr9f2cg5d2dk5gi2xjjqxih18dx71jpbd71m6q4s URL
    http://beta.quicklisp.org/archive/local-time/2018-12-10/local-time-20181210-git.tgz
    MD5 161762ecff2ffbe4dc68c8dc28472515 NAME local-time FILENAME local-time
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-fad FILENAME cl-fad) (NAME stefil FILENAME stefil))
    DEPENDENCIES (alexandria bordeaux-threads cl-fad stefil) VERSION
    20181210-git SIBLINGS (cl-postgres+local-time) PARASITES (local-time/test)) */
