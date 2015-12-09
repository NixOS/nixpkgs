{ buildErlang, fetchgit }:

buildErlang {
  name = "getopt";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/jcomellas/getopt.git";
    sha256 = "0wp70pmfa7pb0fap9znizap1776qr48r0vr985q3k1k08x2drac6";
  };
}