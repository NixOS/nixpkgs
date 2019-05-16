args @ { fetchurl, ... }:
rec {
  baseName = ''bordeaux-threads'';
  version = ''v0.8.6'';

  parasites = [ "bordeaux-threads/test" ];

  description = ''Bordeaux Threads makes writing portable multi-threaded apps simple.'';

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/bordeaux-threads/2018-07-11/bordeaux-threads-v0.8.6.tgz'';
    sha256 = ''1q3b9dbyz02g6iav5rvzml7c8r0iad9j5kipgwkxj0b8qijjzr1y'';
  };

  packageName = "bordeaux-threads";

  asdFilesToKeep = ["bordeaux-threads.asd"];
  overrides = x: x;
}
/* (SYSTEM bordeaux-threads DESCRIPTION
    Bordeaux Threads makes writing portable multi-threaded apps simple. SHA256
    1q3b9dbyz02g6iav5rvzml7c8r0iad9j5kipgwkxj0b8qijjzr1y URL
    http://beta.quicklisp.org/archive/bordeaux-threads/2018-07-11/bordeaux-threads-v0.8.6.tgz
    MD5 f959d3902694b1fe6de450a854040f86 NAME bordeaux-threads FILENAME
    bordeaux-threads DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION v0.8.6 SIBLINGS NIL PARASITES
    (bordeaux-threads/test)) */
