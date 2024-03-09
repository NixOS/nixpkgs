/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "plump";
  version = "20210630-git";

  description = "An XML / XHTML / HTML parser that aims to be as lenient as possible.";

  deps = [ args."array-utils" args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/plump/2021-06-30/plump-20210630-git.tgz";
    sha256 = "0wx5l2q5hsdshdrmlpnjdlyksw6rl5f2snad18xkmmyiwwn7wv2h";
  };

  packageName = "plump";

  asdFilesToKeep = ["plump.asd"];
  overrides = x: x;
}
/* (SYSTEM plump DESCRIPTION
    An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256
    0wx5l2q5hsdshdrmlpnjdlyksw6rl5f2snad18xkmmyiwwn7wv2h URL
    http://beta.quicklisp.org/archive/plump/2021-06-30/plump-20210630-git.tgz
    MD5 b15f7f4f52893ef41ca8a12e6e959dc1 NAME plump FILENAME plump DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils trivial-indent) VERSION
    20210630-git SIBLINGS (plump-dom plump-lexer plump-parser) PARASITES NIL) */
