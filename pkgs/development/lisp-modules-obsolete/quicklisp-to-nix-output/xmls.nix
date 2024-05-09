/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "xmls";
  version = "3.0.2";

  parasites = [ "xmls/test" "xmls/unit-test" ];

  description = "System lacks description";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/xmls/2018-04-30/xmls-3.0.2.tgz";
    sha256 = "1r7mvw62zjcg45j3hm8jlbiisad2b415pghn6qcmhl03dmgp7kgi";
  };

  packageName = "xmls";

  asdFilesToKeep = ["xmls.asd"];
  overrides = x: x;
}
/* (SYSTEM xmls DESCRIPTION System lacks description SHA256
    1r7mvw62zjcg45j3hm8jlbiisad2b415pghn6qcmhl03dmgp7kgi URL
    http://beta.quicklisp.org/archive/xmls/2018-04-30/xmls-3.0.2.tgz MD5
    2462bab4a5d74e87ef7bdef41cd06dc8 NAME xmls FILENAME xmls DEPS
    ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION 3.0.2
    SIBLINGS NIL PARASITES (xmls/test xmls/unit-test)) */
