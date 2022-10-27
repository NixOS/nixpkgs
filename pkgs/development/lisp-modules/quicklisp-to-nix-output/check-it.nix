/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "check-it";
  version = "20150709-git";

  parasites = [ "check-it-test" ];

  description = "A randomized property-based testing tool for Common Lisp.";

  deps = [ args."alexandria" args."closer-mop" args."optima" args."stefil" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/check-it/2015-07-09/check-it-20150709-git.tgz";
    sha256 = "1bx3ndkkl3w7clkqplhy6c2sz46pcp5w76j610gynzv7scz72iw2";
  };

  packageName = "check-it";

  asdFilesToKeep = ["check-it.asd"];
  overrides = x: x;
}
/* (SYSTEM check-it DESCRIPTION
    A randomized property-based testing tool for Common Lisp. SHA256
    1bx3ndkkl3w7clkqplhy6c2sz46pcp5w76j610gynzv7scz72iw2 URL
    http://beta.quicklisp.org/archive/check-it/2015-07-09/check-it-20150709-git.tgz
    MD5 0baae55e5a9c8c884202cbc51e634c42 NAME check-it FILENAME check-it DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop) (NAME optima FILENAME optima)
     (NAME stefil FILENAME stefil))
    DEPENDENCIES (alexandria closer-mop optima stefil) VERSION 20150709-git
    SIBLINGS NIL PARASITES (check-it-test)) */
