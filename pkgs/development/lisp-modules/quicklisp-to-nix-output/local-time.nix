/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "local-time";
  version = "20210124-git";

  parasites = [ "local-time/test" ];

  description = "A library for manipulating dates and times, based on a paper by Erik Naggum";

  deps = [ args."hu_dot_dwim_dot_stefil" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/local-time/2021-01-24/local-time-20210124-git.tgz";
    sha256 = "0bz5z0rd8gfd22bpqkalaijxlrk806zc010cvgd4qjapbrxzjg3s";
  };

  packageName = "local-time";

  asdFilesToKeep = ["local-time.asd"];
  overrides = x: x;
}
/* (SYSTEM local-time DESCRIPTION
    A library for manipulating dates and times, based on a paper by Erik Naggum
    SHA256 0bz5z0rd8gfd22bpqkalaijxlrk806zc010cvgd4qjapbrxzjg3s URL
    http://beta.quicklisp.org/archive/local-time/2021-01-24/local-time-20210124-git.tgz
    MD5 631d67bc84ae838792717b256f2cdbaf NAME local-time FILENAME local-time
    DEPS
    ((NAME hu.dwim.stefil FILENAME hu_dot_dwim_dot_stefil)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES (hu.dwim.stefil uiop) VERSION 20210124-git SIBLINGS
    (cl-postgres+local-time) PARASITES (local-time/test)) */
