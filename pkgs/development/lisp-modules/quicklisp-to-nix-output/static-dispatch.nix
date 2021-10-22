/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "static-dispatch";
  version = "20211020-git";

  parasites = [ "static-dispatch/test" ];

  description = "Static generic function dispatch for Common Lisp.";

  deps = [ args."agutil" args."alexandria" args."anaphora" args."arrows" args."cl-environments" args."cl-form-types" args."closer-mop" args."collectors" args."fiveam" args."introspect-environment" args."iterate" args."optima" args."parse-declarations-1_dot_0" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/static-dispatch/2021-10-20/static-dispatch-20211020-git.tgz";
    sha256 = "0zm8haaf65a6mw1jwkzf2fhlh19ixq1asjc2kiz1jhdy40qdkkfj";
  };

  packageName = "static-dispatch";

  asdFilesToKeep = ["static-dispatch.asd"];
  overrides = x: x;
}
/* (SYSTEM static-dispatch DESCRIPTION
    Static generic function dispatch for Common Lisp. SHA256
    0zm8haaf65a6mw1jwkzf2fhlh19ixq1asjc2kiz1jhdy40qdkkfj URL
    http://beta.quicklisp.org/archive/static-dispatch/2021-10-20/static-dispatch-20211020-git.tgz
    MD5 f26f461213b1c8b78ede26c692e00442 NAME static-dispatch FILENAME
    static-dispatch DEPS
    ((NAME agutil FILENAME agutil) (NAME alexandria FILENAME alexandria)
     (NAME anaphora FILENAME anaphora) (NAME arrows FILENAME arrows)
     (NAME cl-environments FILENAME cl-environments)
     (NAME cl-form-types FILENAME cl-form-types)
     (NAME closer-mop FILENAME closer-mop)
     (NAME collectors FILENAME collectors) (NAME fiveam FILENAME fiveam)
     (NAME introspect-environment FILENAME introspect-environment)
     (NAME iterate FILENAME iterate) (NAME optima FILENAME optima)
     (NAME parse-declarations-1.0 FILENAME parse-declarations-1_dot_0)
     (NAME symbol-munger FILENAME symbol-munger))
    DEPENDENCIES
    (agutil alexandria anaphora arrows cl-environments cl-form-types closer-mop
     collectors fiveam introspect-environment iterate optima
     parse-declarations-1.0 symbol-munger)
    VERSION 20211020-git SIBLINGS NIL PARASITES (static-dispatch/test)) */
