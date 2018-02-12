args @ { fetchurl, ... }:
rec {
  baseName = ''local-time'';
  version = ''20180131-git'';

  parasites = [ "local-time/test" ];

  description = ''A library for manipulating dates and times, based on a paper by Erik Naggum'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-fad" args."stefil" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/local-time/2018-01-31/local-time-20180131-git.tgz'';
    sha256 = ''1i8km0ndqk1kx914n0chi4c3kkk6m0zk0kplh87fgzwn4lh79rpr'';
  };

  packageName = "local-time";

  asdFilesToKeep = ["local-time.asd"];
  overrides = x: x;
}
/* (SYSTEM local-time DESCRIPTION
    A library for manipulating dates and times, based on a paper by Erik Naggum
    SHA256 1i8km0ndqk1kx914n0chi4c3kkk6m0zk0kplh87fgzwn4lh79rpr URL
    http://beta.quicklisp.org/archive/local-time/2018-01-31/local-time-20180131-git.tgz
    MD5 61982a1f2b29793e00369d9c2b6d1b12 NAME local-time FILENAME local-time
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-fad FILENAME cl-fad) (NAME stefil FILENAME stefil))
    DEPENDENCIES (alexandria bordeaux-threads cl-fad stefil) VERSION
    20180131-git SIBLINGS (cl-postgres+local-time) PARASITES (local-time/test)) */
