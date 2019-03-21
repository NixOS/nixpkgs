args @ { fetchurl, ... }:
rec {
  baseName = ''flexi-streams'';
  version = ''20190107-git'';

  parasites = [ "flexi-streams-test" ];

  description = ''Flexible bivalent streams for Common Lisp'';

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/flexi-streams/2019-01-07/flexi-streams-20190107-git.tgz'';
    sha256 = ''1fqkkvspsdzvrr2rkp6i631m7bwx06j68s19cjzpmnhr9zn696i5'';
  };

  packageName = "flexi-streams";

  asdFilesToKeep = ["flexi-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM flexi-streams DESCRIPTION Flexible bivalent streams for Common Lisp
    SHA256 1fqkkvspsdzvrr2rkp6i631m7bwx06j68s19cjzpmnhr9zn696i5 URL
    http://beta.quicklisp.org/archive/flexi-streams/2019-01-07/flexi-streams-20190107-git.tgz
    MD5 b59014f9f9f0d1b94f161e36e64a35c2 NAME flexi-streams FILENAME
    flexi-streams DEPS
    ((NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES
    (trivial-gray-streams) VERSION 20190107-git SIBLINGS NIL PARASITES
    (flexi-streams-test)) */
