args @ { fetchurl, ... }:
rec {
  baseName = ''local-time'';
  version = ''20180228-git'';

  parasites = [ "local-time/test" ];

  description = ''A library for manipulating dates and times, based on a paper by Erik Naggum'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-fad" args."stefil" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/local-time/2018-02-28/local-time-20180228-git.tgz'';
    sha256 = ''0s38rm8rjr4m34ibrvd42y0qgchfqs1pvfm0yv46wbhgg24jgbm1'';
  };

  packageName = "local-time";

  asdFilesToKeep = ["local-time.asd"];
  overrides = x: x;
}
/* (SYSTEM local-time DESCRIPTION
    A library for manipulating dates and times, based on a paper by Erik Naggum
    SHA256 0s38rm8rjr4m34ibrvd42y0qgchfqs1pvfm0yv46wbhgg24jgbm1 URL
    http://beta.quicklisp.org/archive/local-time/2018-02-28/local-time-20180228-git.tgz
    MD5 6bb475cb979c4ba004ef4f4c970dec47 NAME local-time FILENAME local-time
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-fad FILENAME cl-fad) (NAME stefil FILENAME stefil))
    DEPENDENCIES (alexandria bordeaux-threads cl-fad stefil) VERSION
    20180228-git SIBLINGS (cl-postgres+local-time) PARASITES (local-time/test)) */
