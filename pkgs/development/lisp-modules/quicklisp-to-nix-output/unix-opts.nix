/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "unix-opts";
  version = "20210124-git";

  parasites = [ "unix-opts/tests" ];

  description = "minimalistic parser of command line arguments";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/unix-opts/2021-01-24/unix-opts-20210124-git.tgz";
    sha256 = "1gjjav035n6297vgc4wi3i64516b8sdyi0d02q0nwicciwg6mwsn";
  };

  packageName = "unix-opts";

  asdFilesToKeep = ["unix-opts.asd"];
  overrides = x: x;
}
/* (SYSTEM unix-opts DESCRIPTION minimalistic parser of command line arguments
    SHA256 1gjjav035n6297vgc4wi3i64516b8sdyi0d02q0nwicciwg6mwsn URL
    http://beta.quicklisp.org/archive/unix-opts/2021-01-24/unix-opts-20210124-git.tgz
    MD5 c75d3233c0f2e16793b1ce19bfc83811 NAME unix-opts FILENAME unix-opts DEPS
    NIL DEPENDENCIES NIL VERSION 20210124-git SIBLINGS NIL PARASITES
    (unix-opts/tests)) */
