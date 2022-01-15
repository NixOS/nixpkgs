/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lift";
  version = "20211209-git";

  description = "LIsp Framework for Testing";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lift/2021-12-09/lift-20211209-git.tgz";
    sha256 = "1r3i1gi2kggxbvh6mk58cddp5mi9kh7v23gd3z5q70w7cy69iiy7";
  };

  packageName = "lift";

  asdFilesToKeep = ["lift.asd"];
  overrides = x: x;
}
/* (SYSTEM lift DESCRIPTION LIsp Framework for Testing SHA256
    1r3i1gi2kggxbvh6mk58cddp5mi9kh7v23gd3z5q70w7cy69iiy7 URL
    http://beta.quicklisp.org/archive/lift/2021-12-09/lift-20211209-git.tgz MD5
    b98c58658dba0b84a034aa1f0f68dcc9 NAME lift FILENAME lift DEPS NIL
    DEPENDENCIES NIL VERSION 20211209-git SIBLINGS
    (lift-documentation lift-test) PARASITES NIL) */
