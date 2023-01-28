/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivia_dot_level0";
  version = "trivia-20211020-git";

  description = "Bootstrapping Pattern Matching Library for implementing Trivia";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivia/2021-10-20/trivia-20211020-git.tgz";
    sha256 = "0gf63v42pq8cxr7an177p2mf25n5jpqxdf0zb4xqlm2sydk7ng1g";
  };

  packageName = "trivia.level0";

  asdFilesToKeep = ["trivia.level0.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level0 DESCRIPTION
    Bootstrapping Pattern Matching Library for implementing Trivia SHA256
    0gf63v42pq8cxr7an177p2mf25n5jpqxdf0zb4xqlm2sydk7ng1g URL
    http://beta.quicklisp.org/archive/trivia/2021-10-20/trivia-20211020-git.tgz
    MD5 db933e44824514d8ccc9b2a119008051 NAME trivia.level0 FILENAME
    trivia_dot_level0 DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES
    (alexandria) VERSION trivia-20211020-git SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.fset
     trivia.level1 trivia.level2 trivia.ppcre trivia.quasiquote trivia.test
     trivia.trivial)
    PARASITES NIL) */
