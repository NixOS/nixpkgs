args @ { fetchurl, ... }:
rec {
  baseName = ''type-i'';
  version = ''20190521-git'';

  description = ''Type Inference Utility on Fundamentally 1-arg Predicates'';

  deps = [ args."alexandria" args."closer-mop" args."introspect-environment" args."lisp-namespace" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_trivial" args."trivial-cltl2" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/type-i/2019-05-21/type-i-20190521-git.tgz'';
    sha256 = ''1d79g3vd8s387rqagrkf1nmxax6kq32j1ddjrnx7ly08ib6aca99'';
  };

  packageName = "type-i";

  asdFilesToKeep = ["type-i.asd"];
  overrides = x: x;
}
/* (SYSTEM type-i DESCRIPTION
    Type Inference Utility on Fundamentally 1-arg Predicates SHA256
    1d79g3vd8s387rqagrkf1nmxax6kq32j1ddjrnx7ly08ib6aca99 URL
    http://beta.quicklisp.org/archive/type-i/2019-05-21/type-i-20190521-git.tgz
    MD5 9906855a0650f93186f37e162429e58b NAME type-i FILENAME type-i DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop)
     (NAME introspect-environment FILENAME introspect-environment)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivia.level2 FILENAME trivia_dot_level2)
     (NAME trivia.trivial FILENAME trivia_dot_trivial)
     (NAME trivial-cltl2 FILENAME trivial-cltl2))
    DEPENDENCIES
    (alexandria closer-mop introspect-environment lisp-namespace trivia.level0
     trivia.level1 trivia.level2 trivia.trivial trivial-cltl2)
    VERSION 20190521-git SIBLINGS (type-i.test) PARASITES NIL) */
