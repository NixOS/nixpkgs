/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "moptilities";
  version = "20170403-git";

  description = "Common Lisp MOP utilities";

  deps = [ args."closer-mop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/moptilities/2017-04-03/moptilities-20170403-git.tgz";
    sha256 = "0az01wx60ll3nybqlp21f5bps3fnpqhvvfg6d9x84969wdj7q4q8";
  };

  packageName = "moptilities";

  asdFilesToKeep = ["moptilities.asd"];
  overrides = x: x;
}
/* (SYSTEM moptilities DESCRIPTION Common Lisp MOP utilities SHA256
    0az01wx60ll3nybqlp21f5bps3fnpqhvvfg6d9x84969wdj7q4q8 URL
    http://beta.quicklisp.org/archive/moptilities/2017-04-03/moptilities-20170403-git.tgz
    MD5 b118397be325e60a772ea3631c4f19a4 NAME moptilities FILENAME moptilities
    DEPS ((NAME closer-mop FILENAME closer-mop)) DEPENDENCIES (closer-mop)
    VERSION 20170403-git SIBLINGS (moptilities-test) PARASITES NIL) */
