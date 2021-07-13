/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "generic-cl";
  version = "20201220-git";

  parasites = [ "generic-cl/test" ];

  description = "Standard Common Lisp functions implemented using generic functions.";

  deps = [ args."agutil" args."alexandria" args."anaphora" args."arrows" args."cl-ansi-text" args."cl-colors" args."cl-custom-hash-table" args."cl-environments" args."cl-ppcre" args."closer-mop" args."collectors" args."introspect-environment" args."iterate" args."lisp-namespace" args."optima" args."prove" args."prove-asdf" args."static-dispatch" args."symbol-munger" args."trivia" args."trivia_dot_balland2006" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_trivial" args."trivial-cltl2" args."type-i" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/generic-cl/2020-12-20/generic-cl-20201220-git.tgz";
    sha256 = "02awl64bfykkasv3z9xpiiwq3v9vgcacqagbwvigqdk15hqrknyl";
  };

  packageName = "generic-cl";

  asdFilesToKeep = ["generic-cl.asd"];
  overrides = x: x;
}
/* (SYSTEM generic-cl DESCRIPTION
    Standard Common Lisp functions implemented using generic functions. SHA256
    02awl64bfykkasv3z9xpiiwq3v9vgcacqagbwvigqdk15hqrknyl URL
    http://beta.quicklisp.org/archive/generic-cl/2020-12-20/generic-cl-20201220-git.tgz
    MD5 76aa19981d3addb9a741fd4705d5d3ff NAME generic-cl FILENAME generic-cl
    DEPS
    ((NAME agutil FILENAME agutil) (NAME alexandria FILENAME alexandria)
     (NAME anaphora FILENAME anaphora) (NAME arrows FILENAME arrows)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-colors FILENAME cl-colors)
     (NAME cl-custom-hash-table FILENAME cl-custom-hash-table)
     (NAME cl-environments FILENAME cl-environments)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME closer-mop FILENAME closer-mop)
     (NAME collectors FILENAME collectors)
     (NAME introspect-environment FILENAME introspect-environment)
     (NAME iterate FILENAME iterate)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME optima FILENAME optima) (NAME prove FILENAME prove)
     (NAME prove-asdf FILENAME prove-asdf)
     (NAME static-dispatch FILENAME static-dispatch)
     (NAME symbol-munger FILENAME symbol-munger) (NAME trivia FILENAME trivia)
     (NAME trivia.balland2006 FILENAME trivia_dot_balland2006)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivia.level2 FILENAME trivia_dot_level2)
     (NAME trivia.trivial FILENAME trivia_dot_trivial)
     (NAME trivial-cltl2 FILENAME trivial-cltl2) (NAME type-i FILENAME type-i))
    DEPENDENCIES
    (agutil alexandria anaphora arrows cl-ansi-text cl-colors
     cl-custom-hash-table cl-environments cl-ppcre closer-mop collectors
     introspect-environment iterate lisp-namespace optima prove prove-asdf
     static-dispatch symbol-munger trivia trivia.balland2006 trivia.level0
     trivia.level1 trivia.level2 trivia.trivial trivial-cltl2 type-i)
    VERSION 20201220-git SIBLINGS (generic-cl.util) PARASITES (generic-cl/test)) */
