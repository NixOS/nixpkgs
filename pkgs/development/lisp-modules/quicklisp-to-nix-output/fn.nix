/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fn";
  version = "20171019-git";

  description = "Some macros for lambda brevity";

  deps = [ args."named-readtables" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fn/2017-10-19/fn-20171019-git.tgz";
    sha256 = "0r062ffn31sc7313xlfaa9pwnf2wdkiq4spqlr1lk5r8isvdnzz8";
  };

  packageName = "fn";

  asdFilesToKeep = ["fn.asd"];
  overrides = x: x;
}
/* (SYSTEM fn DESCRIPTION Some macros for lambda brevity SHA256
    0r062ffn31sc7313xlfaa9pwnf2wdkiq4spqlr1lk5r8isvdnzz8 URL
    http://beta.quicklisp.org/archive/fn/2017-10-19/fn-20171019-git.tgz MD5
    0e1cfe5f19ceec8966baa3037772d31e NAME fn FILENAME fn DEPS
    ((NAME named-readtables FILENAME named-readtables)) DEPENDENCIES
    (named-readtables) VERSION 20171019-git SIBLINGS NIL PARASITES NIL) */
