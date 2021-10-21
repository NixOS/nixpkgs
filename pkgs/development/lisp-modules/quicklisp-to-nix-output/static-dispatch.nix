/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "static-dispatch";
  version = "20210807-git";

  parasites = [ "static-dispatch/test" ];

  description = "Static generic function dispatch for Common Lisp.";

  deps = [ args."agutil" args."alexandria" args."anaphora" args."arrows" args."cl-environments" args."cl-form-types" args."closer-mop" args."collectors" args."fiveam" args."introspect-environment" args."iterate" args."optima" args."parse-declarations-1_dot_0" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/static-dispatch/2021-08-07/static-dispatch-20210807-git.tgz";
    sha256 = "1r5sz45mng0dvl77dv771ji95b9csxc0784b7igrk9bcz8npwc2g";
  };

  packageName = "static-dispatch";

  asdFilesToKeep = ["static-dispatch.asd"];
  overrides = x: x;
}
/* (SYSTEM static-dispatch DESCRIPTION
    Static generic function dispatch for Common Lisp. SHA256
    1r5sz45mng0dvl77dv771ji95b9csxc0784b7igrk9bcz8npwc2g URL
    http://beta.quicklisp.org/archive/static-dispatch/2021-08-07/static-dispatch-20210807-git.tgz
    MD5 b9724a680d9802ff690de24193583e20 NAME static-dispatch FILENAME
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
    VERSION 20210807-git SIBLINGS NIL PARASITES (static-dispatch/test)) */
