/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "serapeum";
  version = "20220220-git";

  description = "Utilities beyond Alexandria.";

  deps = [ args."alexandria" args."bordeaux-threads" args."closer-mop" args."global-vars" args."introspect-environment" args."iterate" args."lisp-namespace" args."parse-declarations-1_dot_0" args."parse-number" args."split-sequence" args."string-case" args."trivia" args."trivia_dot_balland2006" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_trivial" args."trivial-cltl2" args."trivial-file-size" args."trivial-garbage" args."trivial-macroexpand-all" args."type-i" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/serapeum/2022-02-20/serapeum-20220220-git.tgz";
    sha256 = "1935vxiwjpqmsxjh40wb3b93bg1prvy9n91f7d0x2ww1a2ai5n8y";
  };

  packageName = "serapeum";

  asdFilesToKeep = ["serapeum.asd"];
  overrides = x: x;
}
/* (SYSTEM serapeum DESCRIPTION Utilities beyond Alexandria. SHA256
    1935vxiwjpqmsxjh40wb3b93bg1prvy9n91f7d0x2ww1a2ai5n8y URL
    http://beta.quicklisp.org/archive/serapeum/2022-02-20/serapeum-20220220-git.tgz
    MD5 9930f215892a3cf240aafcfa21481590 NAME serapeum FILENAME serapeum DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME closer-mop FILENAME closer-mop)
     (NAME global-vars FILENAME global-vars)
     (NAME introspect-environment FILENAME introspect-environment)
     (NAME iterate FILENAME iterate)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME parse-declarations-1.0 FILENAME parse-declarations-1_dot_0)
     (NAME parse-number FILENAME parse-number)
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
     (NAME trivial-macroexpand-all FILENAME trivial-macroexpand-all)
     (NAME type-i FILENAME type-i))
    DEPENDENCIES
    (alexandria bordeaux-threads closer-mop global-vars introspect-environment
     iterate lisp-namespace parse-declarations-1.0 parse-number split-sequence
     string-case trivia trivia.balland2006 trivia.level0 trivia.level1
     trivia.level2 trivia.trivial trivial-cltl2 trivial-file-size
     trivial-garbage trivial-macroexpand-all type-i)
    VERSION 20220220-git SIBLINGS NIL PARASITES NIL) */
