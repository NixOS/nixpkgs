/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivia_dot_level2";
  version = "trivia-20210411-git";

  description = "NON-optimized pattern matcher compatible with OPTIMA, with extensible optimizer interface and clean codebase";

  deps = [ args."alexandria" args."closer-mop" args."lisp-namespace" args."trivia_dot_level0" args."trivia_dot_level1" args."trivial-cltl2" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivia/2021-04-11/trivia-20210411-git.tgz";
    sha256 = "1dy35yhjhzcqsq5rwsan1f9x2ss8wcw55n2jzzgymj1vqvzp5mn8";
  };

  packageName = "trivia.level2";

  asdFilesToKeep = ["trivia.level2.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level2 DESCRIPTION
    NON-optimized pattern matcher compatible with OPTIMA, with extensible optimizer interface and clean codebase
    SHA256 1dy35yhjhzcqsq5rwsan1f9x2ss8wcw55n2jzzgymj1vqvzp5mn8 URL
    http://beta.quicklisp.org/archive/trivia/2021-04-11/trivia-20210411-git.tgz
    MD5 3fde6243390481d089cda082573876f6 NAME trivia.level2 FILENAME
    trivia_dot_level2 DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivial-cltl2 FILENAME trivial-cltl2))
    DEPENDENCIES
    (alexandria closer-mop lisp-namespace trivia.level0 trivia.level1
     trivial-cltl2)
    VERSION trivia-20210411-git SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level0
     trivia.level1 trivia.ppcre trivia.quasiquote trivia.test trivia.trivial)
    PARASITES NIL) */
