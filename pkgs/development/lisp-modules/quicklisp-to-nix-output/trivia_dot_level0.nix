/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivia_dot_level0";
  version = "trivia-20210411-git";

  description = "Bootstrapping Pattern Matching Library for implementing Trivia";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivia/2021-04-11/trivia-20210411-git.tgz";
    sha256 = "1dy35yhjhzcqsq5rwsan1f9x2ss8wcw55n2jzzgymj1vqvzp5mn8";
  };

  packageName = "trivia.level0";

  asdFilesToKeep = ["trivia.level0.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level0 DESCRIPTION
    Bootstrapping Pattern Matching Library for implementing Trivia SHA256
    1dy35yhjhzcqsq5rwsan1f9x2ss8wcw55n2jzzgymj1vqvzp5mn8 URL
    http://beta.quicklisp.org/archive/trivia/2021-04-11/trivia-20210411-git.tgz
    MD5 3fde6243390481d089cda082573876f6 NAME trivia.level0 FILENAME
    trivia_dot_level0 DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES
    (alexandria) VERSION trivia-20210411-git SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level1
     trivia.level2 trivia.ppcre trivia.quasiquote trivia.test trivia.trivial)
    PARASITES NIL) */
