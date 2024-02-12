/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "s-xml";
  version = "20150608-git";

  parasites = [ "s-xml.examples" "s-xml.test" ];

  description = "Simple Common Lisp XML Parser";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/s-xml/2015-06-08/s-xml-20150608-git.tgz";
    sha256 = "0cy36wqzasqma4maw9djq1vdwsp5hxq8svlbnhbv9sq9zzys5viq";
  };

  packageName = "s-xml";

  asdFilesToKeep = ["s-xml.asd"];
  overrides = x: x;
}
/* (SYSTEM s-xml DESCRIPTION Simple Common Lisp XML Parser SHA256
    0cy36wqzasqma4maw9djq1vdwsp5hxq8svlbnhbv9sq9zzys5viq URL
    http://beta.quicklisp.org/archive/s-xml/2015-06-08/s-xml-20150608-git.tgz
    MD5 9c31c80f0661777c493fab683f776716 NAME s-xml FILENAME s-xml DEPS NIL
    DEPENDENCIES NIL VERSION 20150608-git SIBLINGS NIL PARASITES
    (s-xml.examples s-xml.test)) */
