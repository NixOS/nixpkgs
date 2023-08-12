/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "esrap-peg";
  version = "20191007-git";

  description = "A wrapper around Esrap to allow generating Esrap grammars from PEG definitions";

  deps = [ args."alexandria" args."cl-unification" args."esrap" args."iterate" args."trivial-with-current-source-form" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/esrap-peg/2019-10-07/esrap-peg-20191007-git.tgz";
    sha256 = "0285ngcm73rpzmr0ydy6frps2b4q6n4jymjv3ncwsh81x5blfvis";
  };

  packageName = "esrap-peg";

  asdFilesToKeep = ["esrap-peg.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap-peg DESCRIPTION
    A wrapper around Esrap to allow generating Esrap grammars from PEG definitions
    SHA256 0285ngcm73rpzmr0ydy6frps2b4q6n4jymjv3ncwsh81x5blfvis URL
    http://beta.quicklisp.org/archive/esrap-peg/2019-10-07/esrap-peg-20191007-git.tgz
    MD5 48d87d3118febeefc23ca3a8dda36fc0 NAME esrap-peg FILENAME esrap-peg DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-unification FILENAME cl-unification) (NAME esrap FILENAME esrap)
     (NAME iterate FILENAME iterate)
     (NAME trivial-with-current-source-form FILENAME
      trivial-with-current-source-form))
    DEPENDENCIES
    (alexandria cl-unification esrap iterate trivial-with-current-source-form)
    VERSION 20191007-git SIBLINGS NIL PARASITES NIL) */
