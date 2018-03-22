args @ { fetchurl, ... }:
rec {
  baseName = ''flexi-streams'';
  version = ''20171227-git'';

  parasites = [ "flexi-streams-test" ];

  description = ''Flexible bivalent streams for Common Lisp'';

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/flexi-streams/2017-12-27/flexi-streams-20171227-git.tgz'';
    sha256 = ''1hw3w8syz7pyggxz1fwskrvjjwz5518vz5clkkjxfshlzqhwxfyc'';
  };

  packageName = "flexi-streams";

  asdFilesToKeep = ["flexi-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM flexi-streams DESCRIPTION Flexible bivalent streams for Common Lisp
    SHA256 1hw3w8syz7pyggxz1fwskrvjjwz5518vz5clkkjxfshlzqhwxfyc URL
    http://beta.quicklisp.org/archive/flexi-streams/2017-12-27/flexi-streams-20171227-git.tgz
    MD5 583aa697051062a0d6a6a73923f865d3 NAME flexi-streams FILENAME
    flexi-streams DEPS
    ((NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES
    (trivial-gray-streams) VERSION 20171227-git SIBLINGS NIL PARASITES
    (flexi-streams-test)) */
