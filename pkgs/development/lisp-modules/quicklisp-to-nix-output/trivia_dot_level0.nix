/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivia_dot_level0";
  version = "trivia-20210630-git";

  description = "Bootstrapping Pattern Matching Library for implementing Trivia";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivia/2021-06-30/trivia-20210630-git.tgz";
    sha256 = "065bfypzahli8pvnbpiwsvxdp2i216gqr1a1algxkpikifrxkjas";
  };

  packageName = "trivia.level0";

  asdFilesToKeep = ["trivia.level0.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level0 DESCRIPTION
    Bootstrapping Pattern Matching Library for implementing Trivia SHA256
    065bfypzahli8pvnbpiwsvxdp2i216gqr1a1algxkpikifrxkjas URL
    http://beta.quicklisp.org/archive/trivia/2021-06-30/trivia-20210630-git.tgz
    MD5 e048a0e20ca12904c032d933795c5e31 NAME trivia.level0 FILENAME
    trivia_dot_level0 DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES
    (alexandria) VERSION trivia-20210630-git SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.fset
     trivia.level1 trivia.level2 trivia.ppcre trivia.quasiquote trivia.test
     trivia.trivial)
    PARASITES NIL) */
