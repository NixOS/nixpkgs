/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cxml";
  version = "20200610-git";

  parasites = [ "cxml/dom" "cxml/klacks" "cxml/test" "cxml/xml" ];

  description = "Closure XML - a Common Lisp XML parser";

  deps = [ args."alexandria" args."babel" args."closure-common" args."puri" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cxml/2020-06-10/cxml-20200610-git.tgz";
    sha256 = "0545rh4mfxqx2yn9b48s0hzd5w80kars7hpykbg0lgf7ys5218mq";
  };

  packageName = "cxml";

  asdFilesToKeep = ["cxml.asd"];
  overrides = x: x;
}
/* (SYSTEM cxml DESCRIPTION Closure XML - a Common Lisp XML parser SHA256
    0545rh4mfxqx2yn9b48s0hzd5w80kars7hpykbg0lgf7ys5218mq URL
    http://beta.quicklisp.org/archive/cxml/2020-06-10/cxml-20200610-git.tgz MD5
    0b6f34edb79f7b63cc5855f18d0d66f0 NAME cxml FILENAME cxml DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME closure-common FILENAME closure-common) (NAME puri FILENAME puri)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel closure-common puri trivial-features
     trivial-gray-streams)
    VERSION 20200610-git SIBLINGS (cxml-dom cxml-klacks cxml-test) PARASITES
    (cxml/dom cxml/klacks cxml/test cxml/xml)) */
