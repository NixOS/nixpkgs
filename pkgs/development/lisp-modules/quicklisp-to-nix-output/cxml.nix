args @ { fetchurl, ... }:
rec {
  baseName = ''cxml'';
  version = ''20181018-git'';

  parasites = [ "cxml/dom" "cxml/klacks" "cxml/test" "cxml/xml" ];

  description = ''Closure XML - a Common Lisp XML parser'';

  deps = [ args."alexandria" args."babel" args."closure-common" args."puri" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cxml/2018-10-18/cxml-20181018-git.tgz'';
    sha256 = ''1s7nfq5zfpxsrayhn0gg3x8fj47mld00qm3cpv5whdqj3wd3krmn'';
  };

  packageName = "cxml";

  asdFilesToKeep = ["cxml.asd"];
  overrides = x: x;
}
/* (SYSTEM cxml DESCRIPTION Closure XML - a Common Lisp XML parser SHA256
    1s7nfq5zfpxsrayhn0gg3x8fj47mld00qm3cpv5whdqj3wd3krmn URL
    http://beta.quicklisp.org/archive/cxml/2018-10-18/cxml-20181018-git.tgz MD5
    33c5546de7099d65fdb2fbb716fd3de8 NAME cxml FILENAME cxml DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME closure-common FILENAME closure-common) (NAME puri FILENAME puri)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel closure-common puri trivial-features
     trivial-gray-streams)
    VERSION 20181018-git SIBLINGS (cxml-dom cxml-klacks cxml-test) PARASITES
    (cxml/dom cxml/klacks cxml/test cxml/xml)) */
