args @ { fetchurl, ... }:
rec {
  baseName = ''local-time'';
  version = ''20190710-git'';

  parasites = [ "local-time/test" ];

  description = ''A library for manipulating dates and times, based on a paper by Erik Naggum'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-fad" args."stefil" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/local-time/2019-07-10/local-time-20190710-git.tgz'';
    sha256 = ''1f6l5g4frb2cyqdyyr64wdhp3fralshm43q7rigsrcz2vx5y75jk'';
  };

  packageName = "local-time";

  asdFilesToKeep = ["local-time.asd"];
  overrides = x: x;
}
/* (SYSTEM local-time DESCRIPTION
    A library for manipulating dates and times, based on a paper by Erik Naggum
    SHA256 1f6l5g4frb2cyqdyyr64wdhp3fralshm43q7rigsrcz2vx5y75jk URL
    http://beta.quicklisp.org/archive/local-time/2019-07-10/local-time-20190710-git.tgz
    MD5 ff315f40d1f955210c78aa0804a117f2 NAME local-time FILENAME local-time
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-fad FILENAME cl-fad) (NAME stefil FILENAME stefil))
    DEPENDENCIES (alexandria bordeaux-threads cl-fad stefil) VERSION
    20190710-git SIBLINGS (cl-postgres+local-time) PARASITES (local-time/test)) */
