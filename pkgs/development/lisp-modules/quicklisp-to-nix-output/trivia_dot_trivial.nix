args @ { fetchurl, ... }:
rec {
  baseName = ''trivia_dot_trivial'';
  version = ''trivia-20200925-git'';

  description = ''Base level system of Trivia with a trivial optimizer.
 Systems that intend to enhance Trivia should depend on this package, not the TRIVIA system,
 in order to avoid the circular dependency.'';

  deps = [ args."alexandria" args."closer-mop" args."lisp-namespace" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivial-cltl2" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivia/2020-09-25/trivia-20200925-git.tgz'';
    sha256 = ''192306pdx50nikph36swipdy2xz1jqrr8p9c3bi91m8qws75wi4z'';
  };

  packageName = "trivia.trivial";

  asdFilesToKeep = ["trivia.trivial.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.trivial DESCRIPTION
    Base level system of Trivia with a trivial optimizer.
 Systems that intend to enhance Trivia should depend on this package, not the TRIVIA system,
 in order to avoid the circular dependency.
    SHA256 192306pdx50nikph36swipdy2xz1jqrr8p9c3bi91m8qws75wi4z URL
    http://beta.quicklisp.org/archive/trivia/2020-09-25/trivia-20200925-git.tgz
    MD5 c6546ecf272e52e051a9d3946242511b NAME trivia.trivial FILENAME
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
    VERSION trivia-20200925-git SIBLINGS
    (trivia trivia.balland2006 trivia.benchmark trivia.cffi trivia.level0
     trivia.level1 trivia.level2 trivia.ppcre trivia.quasiquote trivia.test)
    PARASITES NIL) */
