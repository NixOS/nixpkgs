/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivia_dot_level1";
  version = "trivia-20210228-git";

  description = "Core patterns of Trivia";

  deps = [ args."alexandria" args."trivia_dot_level0" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivia/2021-02-28/trivia-20210228-git.tgz";
    sha256 = "0qqyspq2mryl87wgrm43sj7d2wqb1pckk7fjvnmmyrf5kz5p4pc6";
  };

  packageName = "trivia.level1";

  asdFilesToKeep = ["trivia.level1.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level1 DESCRIPTION Core patterns of Trivia SHA256
    0qqyspq2mryl87wgrm43sj7d2wqb1pckk7fjvnmmyrf5kz5p4pc6 URL
    http://beta.quicklisp.org/archive/trivia/2021-02-28/trivia-20210228-git.tgz
    MD5 b374212a63c1e3b7e5c0e26348516106 NAME trivia.level1 FILENAME
    trivia_dot_level1 DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivia.level0 FILENAME trivia_dot_level0))
    DEPENDENCIES (alexandria trivia.level0) VERSION trivia-20210228-git
    SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level0
     trivia.level2 trivia.ppcre trivia.quasiquote trivia.test trivia.trivial)
    PARASITES NIL) */
