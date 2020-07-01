args @ { fetchurl, ... }:
rec {
  baseName = ''trivia_dot_level2'';
  version = ''trivia-20191227-git'';

  description = ''NON-optimized pattern matcher compatible with OPTIMA, with extensible optimizer interface and clean codebase'';

  deps = [ args."alexandria" args."closer-mop" args."lisp-namespace" args."trivia_dot_level0" args."trivia_dot_level1" args."trivial-cltl2" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivia/2019-12-27/trivia-20191227-git.tgz'';
    sha256 = ''1hn6klc2jlh2qhlc4zr9fi02kqlyfyh5bkcgirql1m06g4j8qi4q'';
  };

  packageName = "trivia.level2";

  asdFilesToKeep = ["trivia.level2.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.level2 DESCRIPTION
    NON-optimized pattern matcher compatible with OPTIMA, with extensible optimizer interface and clean codebase
    SHA256 1hn6klc2jlh2qhlc4zr9fi02kqlyfyh5bkcgirql1m06g4j8qi4q URL
    http://beta.quicklisp.org/archive/trivia/2019-12-27/trivia-20191227-git.tgz
    MD5 645f0e0fcf57ab37ebd4f0a1b7b05854 NAME trivia.level2 FILENAME
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
    VERSION trivia-20191227-git SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level0
     trivia.level1 trivia.ppcre trivia.quasiquote trivia.test trivia.trivial)
    PARASITES NIL) */
