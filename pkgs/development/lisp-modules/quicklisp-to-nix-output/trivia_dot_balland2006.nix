args @ { fetchurl, ... }:
rec {
  baseName = ''trivia_dot_balland2006'';
  version = ''trivia-20200925-git'';

  description = ''Optimizer for Trivia based on (Balland 2006)'';

  deps = [ args."alexandria" args."closer-mop" args."introspect-environment" args."iterate" args."lisp-namespace" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_trivial" args."trivial-cltl2" args."type-i" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivia/2020-09-25/trivia-20200925-git.tgz'';
    sha256 = ''192306pdx50nikph36swipdy2xz1jqrr8p9c3bi91m8qws75wi4z'';
  };

  packageName = "trivia.balland2006";

  asdFilesToKeep = ["trivia.balland2006.asd"];
  overrides = x: x;
}
/* (SYSTEM trivia.balland2006 DESCRIPTION
    Optimizer for Trivia based on (Balland 2006) SHA256
    192306pdx50nikph36swipdy2xz1jqrr8p9c3bi91m8qws75wi4z URL
    http://beta.quicklisp.org/archive/trivia/2020-09-25/trivia-20200925-git.tgz
    MD5 c6546ecf272e52e051a9d3946242511b NAME trivia.balland2006 FILENAME
    trivia_dot_balland2006 DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop)
     (NAME introspect-environment FILENAME introspect-environment)
     (NAME iterate FILENAME iterate)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivia.level2 FILENAME trivia_dot_level2)
     (NAME trivia.trivial FILENAME trivia_dot_trivial)
     (NAME trivial-cltl2 FILENAME trivial-cltl2) (NAME type-i FILENAME type-i))
    DEPENDENCIES
    (alexandria closer-mop introspect-environment iterate lisp-namespace
     trivia.level0 trivia.level1 trivia.level2 trivia.trivial trivial-cltl2
     type-i)
    VERSION trivia-20200925-git SIBLINGS
    (trivia trivia.benchmark trivia.cffi trivia.level0 trivia.level1
     trivia.level2 trivia.ppcre trivia.quasiquote trivia.test trivia.trivial)
    PARASITES NIL) */
