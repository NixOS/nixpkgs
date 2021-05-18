/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "agutil";
  version = "20200325-git";

  description = "A collection of utility functions not found in other utility libraries.";

  deps = [ args."alexandria" args."closer-mop" args."introspect-environment" args."iterate" args."lisp-namespace" args."trivia" args."trivia_dot_balland2006" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_trivial" args."trivial-cltl2" args."type-i" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/agutil/2020-03-25/agutil-20200325-git.tgz";
    sha256 = "0jfbb2x3f8sm507r63qwrzx44lyyj98i36yyyaf4kpyqfir35z2k";
  };

  packageName = "agutil";

  asdFilesToKeep = ["agutil.asd"];
  overrides = x: x;
}
/* (SYSTEM agutil DESCRIPTION
    A collection of utility functions not found in other utility libraries.
    SHA256 0jfbb2x3f8sm507r63qwrzx44lyyj98i36yyyaf4kpyqfir35z2k URL
    http://beta.quicklisp.org/archive/agutil/2020-03-25/agutil-20200325-git.tgz
    MD5 89e47bd15c0f9930a5025d04b9706b60 NAME agutil FILENAME agutil DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop)
     (NAME introspect-environment FILENAME introspect-environment)
     (NAME iterate FILENAME iterate)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME trivia FILENAME trivia)
     (NAME trivia.balland2006 FILENAME trivia_dot_balland2006)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivia.level2 FILENAME trivia_dot_level2)
     (NAME trivia.trivial FILENAME trivia_dot_trivial)
     (NAME trivial-cltl2 FILENAME trivial-cltl2) (NAME type-i FILENAME type-i))
    DEPENDENCIES
    (alexandria closer-mop introspect-environment iterate lisp-namespace trivia
     trivia.balland2006 trivia.level0 trivia.level1 trivia.level2
     trivia.trivial trivial-cltl2 type-i)
    VERSION 20200325-git SIBLINGS NIL PARASITES NIL) */
