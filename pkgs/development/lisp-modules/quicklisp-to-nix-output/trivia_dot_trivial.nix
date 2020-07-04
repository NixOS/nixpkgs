args @ { fetchurl, ... }:
rec {
  baseName = ''trivia_dot_trivial'';
  version = ''trivia-20191227-git'';

  description = ''Base level system of Trivia with a trivial optimizer.
 Systems that intend to enhance Trivia should depend on this package, not the TRIVIA system,
 in order to avoid the circular dependency.'';

  deps = [ args."alexandria" args."closer-mop" args."lisp-namespace" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivial-cltl2" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivia/2019-12-27/trivia-20191227-git.tgz'';
    sha256 = ''1hn6klc2jlh2qhlc4zr9fi02kqlyfyh5bkcgirql1m06g4j8qi4q'';
  };

  packageName = "trivia.trivial";

  asdFilesToKeep = ["trivia.trivial.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.trivial DESCRIPTION
    Base level system of Trivia with a trivial optimizer.
 Systems that intend to enhance Trivia should depend on this package, not the TRIVIA system,
 in order to avoid the circular dependency.
    SHA256 1hn6klc2jlh2qhlc4zr9fi02kqlyfyh5bkcgirql1m06g4j8qi4q URL
    http://beta.quicklisp.org/archive/trivia/2019-12-27/trivia-20191227-git.tgz
    MD5 645f0e0fcf57ab37ebd4f0a1b7b05854 NAME trivia.trivial FILENAME
    trivia_dot_trivial DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivia.level2 FILENAME trivia_dot_level2)
     (NAME trivial-cltl2 FILENAME trivial-cltl2))
    DEPENDENCIES
    (alexandria closer-mop lisp-namespace trivia.level0 trivia.level1
     trivia.level2 trivial-cltl2)
    VERSION trivia-20191227-git SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level0
     trivia.level1 trivia.level2 trivia.ppcre trivia.quasiquote trivia.test)
    PARASITES NIL) */
