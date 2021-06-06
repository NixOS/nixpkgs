/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "static-dispatch";
  version = "20210411-git";

  parasites = [ "static-dispatch/test" ];

  description = "Static generic function dispatch for Common Lisp.";

  deps = [ args."agutil" args."alexandria" args."anaphora" args."arrows" args."cl-ansi-text" args."cl-colors" args."cl-environments" args."cl-interpol" args."closer-mop" args."collectors" args."introspect-environment" args."iterate" args."lisp-namespace" args."optima" args."prove" args."prove-asdf" args."symbol-munger" args."trivia" args."trivia_dot_balland2006" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_trivial" args."trivial-cltl2" args."type-i" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/static-dispatch/2021-04-11/static-dispatch-20210411-git.tgz";
    sha256 = "0dqkapripvb5qrhpim1b5y2ymn99s2zcwf38vmqyiqk3n3hvjjh1";
  };

  packageName = "static-dispatch";

  asdFilesToKeep = ["static-dispatch.asd"];
  overrides = x: x;
}
/* (SYSTEM static-dispatch DESCRIPTION
    Static generic function dispatch for Common Lisp. SHA256
    0dqkapripvb5qrhpim1b5y2ymn99s2zcwf38vmqyiqk3n3hvjjh1 URL
    http://beta.quicklisp.org/archive/static-dispatch/2021-04-11/static-dispatch-20210411-git.tgz
    MD5 7af665c6a3a1aa3315fe0a651ca559de NAME static-dispatch FILENAME
    static-dispatch DEPS
    ((NAME agutil FILENAME agutil) (NAME alexandria FILENAME alexandria)
     (NAME anaphora FILENAME anaphora) (NAME arrows FILENAME arrows)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-colors FILENAME cl-colors)
     (NAME cl-environments FILENAME cl-environments)
     (NAME cl-interpol FILENAME cl-interpol)
     (NAME closer-mop FILENAME closer-mop)
     (NAME collectors FILENAME collectors)
     (NAME introspect-environment FILENAME introspect-environment)
     (NAME iterate FILENAME iterate)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME optima FILENAME optima) (NAME prove FILENAME prove)
     (NAME prove-asdf FILENAME prove-asdf)
     (NAME symbol-munger FILENAME symbol-munger) (NAME trivia FILENAME trivia)
     (NAME trivia.balland2006 FILENAME trivia_dot_balland2006)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivia.level2 FILENAME trivia_dot_level2)
     (NAME trivia.trivial FILENAME trivia_dot_trivial)
     (NAME trivial-cltl2 FILENAME trivial-cltl2) (NAME type-i FILENAME type-i))
    DEPENDENCIES
    (agutil alexandria anaphora arrows cl-ansi-text cl-colors cl-environments
     cl-interpol closer-mop collectors introspect-environment iterate
     lisp-namespace optima prove prove-asdf symbol-munger trivia
     trivia.balland2006 trivia.level0 trivia.level1 trivia.level2
     trivia.trivial trivial-cltl2 type-i)
    VERSION 20210411-git SIBLINGS NIL PARASITES (static-dispatch/test)) */
