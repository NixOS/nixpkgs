/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "zpb-ttf";
  version = "release-1.0.4";

  description = "Access TrueType font metrics and outlines from Common Lisp";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/zpb-ttf/2021-01-24/zpb-ttf-release-1.0.4.tgz";
    sha256 = "186jzhmklby2pkmwv3zxw09qh8023f7w5ng2ql46l6abx146s3ll";
  };

  packageName = "zpb-ttf";

  asdFilesToKeep = ["zpb-ttf.asd"];
  overrides = x: x;
}
/* (SYSTEM zpb-ttf DESCRIPTION
    Access TrueType font metrics and outlines from Common Lisp SHA256
    186jzhmklby2pkmwv3zxw09qh8023f7w5ng2ql46l6abx146s3ll URL
    http://beta.quicklisp.org/archive/zpb-ttf/2021-01-24/zpb-ttf-release-1.0.4.tgz
    MD5 b66f67b0a1fc347657d4d71ddb304920 NAME zpb-ttf FILENAME zpb-ttf DEPS NIL
    DEPENDENCIES NIL VERSION release-1.0.4 SIBLINGS NIL PARASITES NIL) */
