/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "xpath";
  version = "plexippus-20190521-git";

  parasites = [ "xpath/test" ];

  description = "An implementation of the XML Path Language (XPath) Version 1.0";

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."closure-common" args."cxml" args."parse-number" args."puri" args."trivial-features" args."trivial-gray-streams" args."yacc" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/plexippus-xpath/2019-05-21/plexippus-xpath-20190521-git.tgz";
    sha256 = "15357w1rlmahld4rh8avix7m40mwiiv7n2vlyc57ldw2k1m0n7xa";
  };

  packageName = "xpath";

  asdFilesToKeep = ["xpath.asd"];
  overrides = x: x;
}
/* (SYSTEM xpath DESCRIPTION
    An implementation of the XML Path Language (XPath) Version 1.0 SHA256
    15357w1rlmahld4rh8avix7m40mwiiv7n2vlyc57ldw2k1m0n7xa URL
    http://beta.quicklisp.org/archive/plexippus-xpath/2019-05-21/plexippus-xpath-20190521-git.tgz
    MD5 eb9a4c39a7c37aa0338c401713b3f944 NAME xpath FILENAME xpath DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closure-common FILENAME closure-common) (NAME cxml FILENAME cxml)
     (NAME parse-number FILENAME parse-number) (NAME puri FILENAME puri)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME yacc FILENAME yacc))
    DEPENDENCIES
    (alexandria babel cl-ppcre closure-common cxml parse-number puri
     trivial-features trivial-gray-streams yacc)
    VERSION plexippus-20190521-git SIBLINGS NIL PARASITES (xpath/test)) */
