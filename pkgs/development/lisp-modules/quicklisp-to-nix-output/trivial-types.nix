/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-types";
  version = "20120407-git";

  description = "Trivial type definitions";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-types/2012-04-07/trivial-types-20120407-git.tgz";
    sha256 = "0y3lfbbvi2qp2cwswzmk1awzqrsrrcfkcm1qn744bgm1fiqhxbxx";
  };

  packageName = "trivial-types";

  asdFilesToKeep = ["trivial-types.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-types DESCRIPTION Trivial type definitions SHA256
    0y3lfbbvi2qp2cwswzmk1awzqrsrrcfkcm1qn744bgm1fiqhxbxx URL
    http://beta.quicklisp.org/archive/trivial-types/2012-04-07/trivial-types-20120407-git.tgz
    MD5 b14dbe0564dcea33d8f4e852a612d7db NAME trivial-types FILENAME
    trivial-types DEPS NIL DEPENDENCIES NIL VERSION 20120407-git SIBLINGS NIL
    PARASITES NIL) */
