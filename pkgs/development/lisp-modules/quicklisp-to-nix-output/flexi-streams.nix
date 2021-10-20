/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "flexi-streams";
  version = "20210807-git";

  parasites = [ "flexi-streams-test" ];

  description = "Flexible bivalent streams for Common Lisp";

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/flexi-streams/2021-08-07/flexi-streams-20210807-git.tgz";
    sha256 = "1g2cvz0bjigr6lw3gigdwcm1x1w0pcyr3ainnix9wyp1kxc2n2rw";
  };

  packageName = "flexi-streams";

  asdFilesToKeep = ["flexi-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM flexi-streams DESCRIPTION Flexible bivalent streams for Common Lisp
    SHA256 1g2cvz0bjigr6lw3gigdwcm1x1w0pcyr3ainnix9wyp1kxc2n2rw URL
    http://beta.quicklisp.org/archive/flexi-streams/2021-08-07/flexi-streams-20210807-git.tgz
    MD5 6c026daab0766c11f5aee9cc3df3394e NAME flexi-streams FILENAME
    flexi-streams DEPS
    ((NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES
    (trivial-gray-streams) VERSION 20210807-git SIBLINGS NIL PARASITES
    (flexi-streams-test)) */
