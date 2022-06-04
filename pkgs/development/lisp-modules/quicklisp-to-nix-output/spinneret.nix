/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "spinneret";
  version = "20220220-git";

  description = "Common Lisp HTML5 generator.";

  deps = [ args."alexandria" args."anaphora" args."bordeaux-threads" args."cl-ppcre" args."closer-mop" args."global-vars" args."introspect-environment" args."iterate" args."lisp-namespace" args."named-readtables" args."parenscript" args."parse-declarations-1_dot_0" args."parse-number" args."serapeum" args."split-sequence" args."string-case" args."trivia" args."trivia_dot_balland2006" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_trivial" args."trivial-cltl2" args."trivial-file-size" args."trivial-garbage" args."trivial-gray-streams" args."trivial-macroexpand-all" args."type-i" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/spinneret/2022-02-20/spinneret-20220220-git.tgz";
    sha256 = "06pfaxlxjdp6vkin0lczsmnljxyl6cjskxj23qs8f6fqas6r3kjy";
  };

  packageName = "spinneret";

  asdFilesToKeep = ["spinneret.asd"];
  overrides = x: x;
}
/* (SYSTEM spinneret DESCRIPTION Common Lisp HTML5 generator. SHA256
    06pfaxlxjdp6vkin0lczsmnljxyl6cjskxj23qs8f6fqas6r3kjy URL
    http://beta.quicklisp.org/archive/spinneret/2022-02-20/spinneret-20220220-git.tgz
    MD5 f2822f2362e1f4f01fd127a8cef68721 NAME spinneret FILENAME spinneret DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME closer-mop FILENAME closer-mop)
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
     (NAME trivia.trivial FILENAME trivia_dot_trivial)
     (NAME trivial-cltl2 FILENAME trivial-cltl2)
     (NAME trivial-file-size FILENAME trivial-file-size)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-macroexpand-all FILENAME trivial-macroexpand-all)
     (NAME type-i FILENAME type-i))
    DEPENDENCIES
    (alexandria anaphora bordeaux-threads cl-ppcre closer-mop global-vars
     introspect-environment iterate lisp-namespace named-readtables parenscript
     parse-declarations-1.0 parse-number serapeum split-sequence string-case
     trivia trivia.balland2006 trivia.level0 trivia.level1 trivia.level2
     trivia.trivial trivial-cltl2 trivial-file-size trivial-garbage
     trivial-gray-streams trivial-macroexpand-all type-i)
    VERSION 20220220-git SIBLINGS NIL PARASITES NIL) */
