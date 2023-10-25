/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "uiop";
  version = "3.3.5";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/uiop/2021-08-07/uiop-3.3.5.tgz";
    sha256 = "19bskbcv413ix2rjqlbj9y62qbm6780s5i7h00rvpd488nnrvaqk";
  };

  packageName = "uiop";

  asdFilesToKeep = ["uiop.asd"];
  overrides = x: x;
}
/* (SYSTEM uiop DESCRIPTION System lacks description SHA256
    19bskbcv413ix2rjqlbj9y62qbm6780s5i7h00rvpd488nnrvaqk URL
    http://beta.quicklisp.org/archive/uiop/2021-08-07/uiop-3.3.5.tgz MD5
    831138297c2ac03189d25bb6b03b919c NAME uiop FILENAME uiop DEPS NIL
    DEPENDENCIES NIL VERSION 3.3.5 SIBLINGS (asdf-driver) PARASITES NIL) */
