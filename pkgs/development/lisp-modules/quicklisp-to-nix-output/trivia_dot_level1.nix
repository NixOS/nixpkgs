/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivia_dot_level1";
  version = "trivia-20210411-git";

  description = "Core patterns of Trivia";

  deps = [ args."alexandria" args."trivia_dot_level0" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivia/2021-04-11/trivia-20210411-git.tgz";
    sha256 = "1dy35yhjhzcqsq5rwsan1f9x2ss8wcw55n2jzzgymj1vqvzp5mn8";
  };

  packageName = "trivia.level1";

  asdFilesToKeep = ["trivia.level1.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level1 DESCRIPTION Core patterns of Trivia SHA256
    1dy35yhjhzcqsq5rwsan1f9x2ss8wcw55n2jzzgymj1vqvzp5mn8 URL
    http://beta.quicklisp.org/archive/trivia/2021-04-11/trivia-20210411-git.tgz
    MD5 3fde6243390481d089cda082573876f6 NAME trivia.level1 FILENAME
    trivia_dot_level1 DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivia.level0 FILENAME trivia_dot_level0))
    DEPENDENCIES (alexandria trivia.level0) VERSION trivia-20210411-git
    SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level0
     trivia.level2 trivia.ppcre trivia.quasiquote trivia.test trivia.trivial)
    PARASITES NIL) */
