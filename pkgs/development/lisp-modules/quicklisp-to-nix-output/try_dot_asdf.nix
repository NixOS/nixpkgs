/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "try_dot_asdf";
  version = "try-20220220-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/try/2022-02-20/try-20220220-git.tgz";
    sha256 = "0airdqwram23rczcfas2z2l8liwc4zwg14y972xzgrdi0nlw0xvh";
  };

  packageName = "try.asdf";

  asdFilesToKeep = ["try.asdf.asd"];
  overrides = x: x;
}
/* (SYSTEM try.asdf DESCRIPTION System lacks description SHA256
    0airdqwram23rczcfas2z2l8liwc4zwg14y972xzgrdi0nlw0xvh URL
    http://beta.quicklisp.org/archive/try/2022-02-20/try-20220220-git.tgz MD5
    b871e436d3cc7953d147061de1175a14 NAME try.asdf FILENAME try_dot_asdf DEPS
    NIL DEPENDENCIES NIL VERSION try-20220220-git SIBLINGS (try) PARASITES NIL) */
