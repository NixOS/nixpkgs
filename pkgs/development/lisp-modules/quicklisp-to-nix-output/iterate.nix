args @ { fetchurl, ... }:
rec {
  baseName = ''iterate'';
  version = ''20200610-git'';

  parasites = [ "iterate/tests" ];

  description = ''Jonathan Amsterdam's iterator/gatherer/accumulator facility'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iterate/2020-06-10/iterate-20200610-git.tgz'';
    sha256 = ''0xz3v321b8zgjsgak432frs0gmpr2n24sf5gq97qnqvwqfn4infb'';
  };

  packageName = "iterate";

  asdFilesToKeep = ["iterate.asd"];
  overrides = x: x;
}
/* (SYSTEM iterate DESCRIPTION
    Jonathan Amsterdam's iterator/gatherer/accumulator facility SHA256
    0xz3v321b8zgjsgak432frs0gmpr2n24sf5gq97qnqvwqfn4infb URL
    http://beta.quicklisp.org/archive/iterate/2020-06-10/iterate-20200610-git.tgz
    MD5 289e02704d6312910d07601bc563f0a5 NAME iterate FILENAME iterate DEPS NIL
    DEPENDENCIES NIL VERSION 20200610-git SIBLINGS NIL PARASITES
    (iterate/tests)) */
