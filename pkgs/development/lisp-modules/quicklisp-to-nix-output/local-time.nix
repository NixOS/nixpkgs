args @ { fetchurl, ... }:
rec {
  baseName = ''local-time'';
  version = ''20200925-git'';

  parasites = [ "local-time/test" ];

  description = ''A library for manipulating dates and times, based on a paper by Erik Naggum'';

  deps = [ args."stefil" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/local-time/2020-09-25/local-time-20200925-git.tgz'';
    sha256 = ''0rr2bs93vhj7ngplw85572jfx8250fr2iki8y9spxmfz1sldm12f'';
  };

  packageName = "local-time";

  asdFilesToKeep = ["local-time.asd"];
  overrides = x: x;
}
/* (SYSTEM local-time DESCRIPTION
    A library for manipulating dates and times, based on a paper by Erik Naggum
    SHA256 0rr2bs93vhj7ngplw85572jfx8250fr2iki8y9spxmfz1sldm12f URL
    http://beta.quicklisp.org/archive/local-time/2020-09-25/local-time-20200925-git.tgz
    MD5 81f29e965b234a498840ff38d0002048 NAME local-time FILENAME local-time
    DEPS ((NAME stefil FILENAME stefil) (NAME uiop FILENAME uiop)) DEPENDENCIES
    (stefil uiop) VERSION 20200925-git SIBLINGS (cl-postgres+local-time)
    PARASITES (local-time/test)) */
