/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "rove";
  version = "20210807-git";

  description = "Yet another testing framework intended to be a successor of Prove";

  deps = [ args."bordeaux-threads" args."dissect" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/rove/2021-08-07/rove-20210807-git.tgz";
    sha256 = "1zg9jch2q8946a1bsjykq0bw86zh9gqvvqbqa8k4njvqbc42kqn8";
  };

  packageName = "rove";

  asdFilesToKeep = ["rove.asd"];
  overrides = x: x;
}
/* (SYSTEM rove DESCRIPTION
    Yet another testing framework intended to be a successor of Prove SHA256
    1zg9jch2q8946a1bsjykq0bw86zh9gqvvqbqa8k4njvqbc42kqn8 URL
    http://beta.quicklisp.org/archive/rove/2021-08-07/rove-20210807-git.tgz MD5
    502337a1120b19d1d70bb06191323ee0 NAME rove FILENAME rove DEPS
    ((NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME dissect FILENAME dissect)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (bordeaux-threads dissect trivial-gray-streams) VERSION
    20210807-git SIBLINGS NIL PARASITES NIL) */
