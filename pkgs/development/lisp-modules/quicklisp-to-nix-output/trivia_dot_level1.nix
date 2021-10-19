/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivia_dot_level1";
  version = "trivia-20210630-git";

  description = "Core patterns of Trivia";

  deps = [ args."alexandria" args."trivia_dot_level0" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivia/2021-06-30/trivia-20210630-git.tgz";
    sha256 = "065bfypzahli8pvnbpiwsvxdp2i216gqr1a1algxkpikifrxkjas";
  };

  packageName = "trivia.level1";

  asdFilesToKeep = ["trivia.level1.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level1 DESCRIPTION Core patterns of Trivia SHA256
    065bfypzahli8pvnbpiwsvxdp2i216gqr1a1algxkpikifrxkjas URL
    http://beta.quicklisp.org/archive/trivia/2021-06-30/trivia-20210630-git.tgz
    MD5 e048a0e20ca12904c032d933795c5e31 NAME trivia.level1 FILENAME
    trivia_dot_level1 DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivia.level0 FILENAME trivia_dot_level0))
    DEPENDENCIES (alexandria trivia.level0) VERSION trivia-20210630-git
    SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.fset
     trivia.level0 trivia.level2 trivia.ppcre trivia.quasiquote trivia.test
     trivia.trivial)
    PARASITES NIL) */
