/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "generic-cl_dot_internal";
  version = "generic-cl-20211020-git";

  description = "Utilities used internally by generic-cl";

  deps = [ args."agutil" args."alexandria" args."anaphora" args."arrows" args."cl-environments" args."cl-form-types" args."closer-mop" args."collectors" args."introspect-environment" args."iterate" args."lisp-namespace" args."optima" args."parse-declarations-1_dot_0" args."static-dispatch" args."symbol-munger" args."trivia" args."trivia_dot_balland2006" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_trivial" args."trivial-cltl2" args."type-i" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/generic-cl/2021-10-20/generic-cl-20211020-git.tgz";
    sha256 = "0jryfmxwqhrarmpbb643b7iv5rlib5pcx4i4jcd6h2rscnrbj8sa";
  };

  packageName = "generic-cl.internal";

  asdFilesToKeep = ["generic-cl.internal.asd"];
  overrides = x: x;
}
/* (SYSTEM generic-cl.internal DESCRIPTION
    Utilities used internally by generic-cl SHA256
    0jryfmxwqhrarmpbb643b7iv5rlib5pcx4i4jcd6h2rscnrbj8sa URL
    http://beta.quicklisp.org/archive/generic-cl/2021-10-20/generic-cl-20211020-git.tgz
    MD5 ce42f45dd7c5be44de45ee259a46d7b8 NAME generic-cl.internal FILENAME
    generic-cl_dot_internal DEPS
    ((NAME agutil FILENAME agutil) (NAME alexandria FILENAME alexandria)
     (NAME anaphora FILENAME anaphora) (NAME arrows FILENAME arrows)
     (NAME cl-environments FILENAME cl-environments)
     (NAME cl-form-types FILENAME cl-form-types)
     (NAME closer-mop FILENAME closer-mop)
     (NAME collectors FILENAME collectors)
     (NAME introspect-environment FILENAME introspect-environment)
     (NAME iterate FILENAME iterate)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME optima FILENAME optima)
     (NAME parse-declarations-1.0 FILENAME parse-declarations-1_dot_0)
     (NAME static-dispatch FILENAME static-dispatch)
     (NAME symbol-munger FILENAME symbol-munger) (NAME trivia FILENAME trivia)
     (NAME trivia.balland2006 FILENAME trivia_dot_balland2006)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivia.level2 FILENAME trivia_dot_level2)
     (NAME trivia.trivial FILENAME trivia_dot_trivial)
     (NAME trivial-cltl2 FILENAME trivial-cltl2) (NAME type-i FILENAME type-i))
    DEPENDENCIES
    (agutil alexandria anaphora arrows cl-environments cl-form-types closer-mop
     collectors introspect-environment iterate lisp-namespace optima
     parse-declarations-1.0 static-dispatch symbol-munger trivia
     trivia.balland2006 trivia.level0 trivia.level1 trivia.level2
     trivia.trivial trivial-cltl2 type-i)
    VERSION generic-cl-20211020-git SIBLINGS
    (generic-cl.arithmetic generic-cl generic-cl.collector
     generic-cl.comparison generic-cl.container generic-cl.iterator
     generic-cl.lazy-seq generic-cl.map generic-cl.math generic-cl.object
     generic-cl.sequence generic-cl.set generic-cl.util)
    PARASITES NIL) */
