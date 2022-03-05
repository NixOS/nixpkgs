/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivia_dot_level1";
  version = "trivia-20211020-git";

  description = "Core patterns of Trivia";

  deps = [ args."alexandria" args."trivia_dot_level0" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivia/2021-10-20/trivia-20211020-git.tgz";
    sha256 = "0gf63v42pq8cxr7an177p2mf25n5jpqxdf0zb4xqlm2sydk7ng1g";
  };

  packageName = "trivia.level1";

  asdFilesToKeep = ["trivia.level1.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level1 DESCRIPTION Core patterns of Trivia SHA256
    0gf63v42pq8cxr7an177p2mf25n5jpqxdf0zb4xqlm2sydk7ng1g URL
    http://beta.quicklisp.org/archive/trivia/2021-10-20/trivia-20211020-git.tgz
    MD5 db933e44824514d8ccc9b2a119008051 NAME trivia.level1 FILENAME
    trivia_dot_level1 DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivia.level0 FILENAME trivia_dot_level0))
    DEPENDENCIES (alexandria trivia.level0) VERSION trivia-20211020-git
    SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.fset
     trivia.level0 trivia.level2 trivia.ppcre trivia.quasiquote trivia.test
     trivia.trivial)
    PARASITES NIL) */
