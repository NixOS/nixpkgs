/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "flexi-streams";
  version = "20200925-git";

  parasites = [ "flexi-streams-test" ];

  description = "Flexible bivalent streams for Common Lisp";

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/flexi-streams/2020-09-25/flexi-streams-20200925-git.tgz";
    sha256 = "1hmsryfkjnk4gdv803s3hpp71fpdybfl1jb5hgngxpd5lsrq0gb2";
  };

  packageName = "flexi-streams";

  asdFilesToKeep = ["flexi-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM flexi-streams DESCRIPTION Flexible bivalent streams for Common Lisp
    SHA256 1hmsryfkjnk4gdv803s3hpp71fpdybfl1jb5hgngxpd5lsrq0gb2 URL
    http://beta.quicklisp.org/archive/flexi-streams/2020-09-25/flexi-streams-20200925-git.tgz
    MD5 0d7bd1e542fe0a0d9728c45f70a95e36 NAME flexi-streams FILENAME
    flexi-streams DEPS
    ((NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES
    (trivial-gray-streams) VERSION 20200925-git SIBLINGS NIL PARASITES
    (flexi-streams-test)) */
