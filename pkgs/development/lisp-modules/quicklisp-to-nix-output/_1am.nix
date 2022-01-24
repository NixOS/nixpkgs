/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "_1am";
  version = "20141106-git";

  description = "A minimal testing framework.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/1am/2014-11-06/1am-20141106-git.tgz";
    sha256 = "0vnnqd4fiq9z34i1k9gqczg3j6xllwba1f6nx0b82sgsdccmsly6";
  };

  packageName = "1am";

  asdFilesToKeep = ["1am.asd"];
  overrides = x: x;
}
/* (SYSTEM 1am DESCRIPTION A minimal testing framework. SHA256
    0vnnqd4fiq9z34i1k9gqczg3j6xllwba1f6nx0b82sgsdccmsly6 URL
    http://beta.quicklisp.org/archive/1am/2014-11-06/1am-20141106-git.tgz MD5
    c5e83c329157518e3ebfeef63e4ac269 NAME 1am FILENAME _1am DEPS NIL
    DEPENDENCIES NIL VERSION 20141106-git SIBLINGS NIL PARASITES NIL) */
