/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "spinneret";
  version = "20211020-git";

  description = "Common Lisp HTML5 generator.";

  deps = [ args."alexandria" args."anaphora" args."babel" args."bordeaux-threads" args."cl-ppcre" args."closer-mop" args."fare-quasiquote" args."fare-quasiquote-extras" args."fare-quasiquote-optima" args."fare-quasiquote-readtable" args."fare-utils" args."global-vars" args."introspect-environment" args."iterate" args."lisp-namespace" args."named-readtables" args."parenscript" args."parse-declarations-1_dot_0" args."parse-number" args."serapeum" args."split-sequence" args."string-case" args."trivia" args."trivia_dot_balland2006" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_quasiquote" args."trivia_dot_trivial" args."trivial-cltl2" args."trivial-features" args."trivial-file-size" args."trivial-garbage" args."trivial-gray-streams" args."trivial-macroexpand-all" args."type-i" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/spinneret/2021-10-20/spinneret-20211020-git.tgz";
    sha256 = "1j3z2sr98j7rd8ssxp8r1yxlj8chvldn0k2nh2vf2jaynhwk3slq";
  };

  packageName = "spinneret";

  asdFilesToKeep = ["spinneret.asd"];
  overrides = x: x;
}
/* (SYSTEM spinneret DESCRIPTION Common Lisp HTML5 generator. SHA256
    1j3z2sr98j7rd8ssxp8r1yxlj8chvldn0k2nh2vf2jaynhwk3slq URL
    http://beta.quicklisp.org/archive/spinneret/2021-10-20/spinneret-20211020-git.tgz
    MD5 f10e1537f3bfd16a0a189d16fd86790b NAME spinneret FILENAME spinneret DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME closer-mop FILENAME closer-mop)
     (NAME fare-quasiquote FILENAME fare-quasiquote)
     (NAME fare-quasiquote-extras FILENAME fare-quasiquote-extras)
     (NAME fare-quasiquote-optima FILENAME fare-quasiquote-optima)
     (NAME fare-quasiquote-readtable FILENAME fare-quasiquote-readtable)
     (NAME fare-utils FILENAME fare-utils)
     (NAME global-vars FILENAME global-vars)
     (NAME introspect-environment FILENAME introspect-environment)
     (NAME iterate FILENAME iterate)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME named-readtables FILENAME named-readtables)
     (NAME parenscript FILENAME parenscript)
     (NAME parse-declarations-1.0 FILENAME parse-declarations-1_dot_0)
     (NAME parse-number FILENAME parse-number)
     (NAME serapeum FILENAME serapeum)
     (NAME split-sequence FILENAME split-sequence)
     (NAME string-case FILENAME string-case) (NAME trivia FILENAME trivia)
     (NAME trivia.balland2006 FILENAME trivia_dot_balland2006)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivia.level2 FILENAME trivia_dot_level2)
     (NAME trivia.quasiquote FILENAME trivia_dot_quasiquote)
     (NAME trivia.trivial FILENAME trivia_dot_trivial)
     (NAME trivial-cltl2 FILENAME trivial-cltl2)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-file-size FILENAME trivial-file-size)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-macroexpand-all FILENAME trivial-macroexpand-all)
     (NAME type-i FILENAME type-i))
    DEPENDENCIES
    (alexandria anaphora babel bordeaux-threads cl-ppcre closer-mop
     fare-quasiquote fare-quasiquote-extras fare-quasiquote-optima
     fare-quasiquote-readtable fare-utils global-vars introspect-environment
     iterate lisp-namespace named-readtables parenscript parse-declarations-1.0
     parse-number serapeum split-sequence string-case trivia trivia.balland2006
     trivia.level0 trivia.level1 trivia.level2 trivia.quasiquote trivia.trivial
     trivial-cltl2 trivial-features trivial-file-size trivial-garbage
     trivial-gray-streams trivial-macroexpand-all type-i)
    VERSION 20211020-git SIBLINGS NIL PARASITES NIL) */
