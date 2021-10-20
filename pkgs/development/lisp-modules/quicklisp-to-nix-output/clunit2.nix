/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clunit2";
  version = "20210630-git";

  description = "CLUnit is a Common Lisp unit testing framework.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clunit2/2021-06-30/clunit2-20210630-git.tgz";
    sha256 = "0vrjgf8rcdhvap9fvq4k543276ybjs5jqxj6zxbhrkfw2p26s445";
  };

  packageName = "clunit2";

  asdFilesToKeep = ["clunit2.asd"];
  overrides = x: x;
}
/* (SYSTEM clunit2 DESCRIPTION CLUnit is a Common Lisp unit testing framework.
    SHA256 0vrjgf8rcdhvap9fvq4k543276ybjs5jqxj6zxbhrkfw2p26s445 URL
    http://beta.quicklisp.org/archive/clunit2/2021-06-30/clunit2-20210630-git.tgz
    MD5 d76550549dec0dca9207970919a8b952 NAME clunit2 FILENAME clunit2 DEPS NIL
    DEPENDENCIES NIL VERSION 20210630-git SIBLINGS NIL PARASITES NIL) */
