/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-form-types";
  version = "20211230-git";

  parasites = [ "cl-form-types/test" ];

  description = "Library for determining types of Common Lisp forms.";

  deps = [ args."agutil" args."alexandria" args."anaphora" args."arrows" args."cl-environments" args."closer-mop" args."collectors" args."fiveam" args."introspect-environment" args."iterate" args."optima" args."parse-declarations-1_dot_0" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-form-types/2021-12-30/cl-form-types-20211230-git.tgz";
    sha256 = "1valmc2mph4yi432l39i0d72bl7m34igvfrv0z83pgnl6yg78zrr";
  };

  packageName = "cl-form-types";

  asdFilesToKeep = ["cl-form-types.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-form-types DESCRIPTION
    Library for determining types of Common Lisp forms. SHA256
    1valmc2mph4yi432l39i0d72bl7m34igvfrv0z83pgnl6yg78zrr URL
    http://beta.quicklisp.org/archive/cl-form-types/2021-12-30/cl-form-types-20211230-git.tgz
    MD5 5516b165131493e7ee85de0bed38a921 NAME cl-form-types FILENAME
    cl-form-types DEPS
    ((NAME agutil FILENAME agutil) (NAME alexandria FILENAME alexandria)
     (NAME anaphora FILENAME anaphora) (NAME arrows FILENAME arrows)
     (NAME cl-environments FILENAME cl-environments)
     (NAME closer-mop FILENAME closer-mop)
     (NAME collectors FILENAME collectors) (NAME fiveam FILENAME fiveam)
     (NAME introspect-environment FILENAME introspect-environment)
     (NAME iterate FILENAME iterate) (NAME optima FILENAME optima)
     (NAME parse-declarations-1.0 FILENAME parse-declarations-1_dot_0)
     (NAME symbol-munger FILENAME symbol-munger))
    DEPENDENCIES
    (agutil alexandria anaphora arrows cl-environments closer-mop collectors
     fiveam introspect-environment iterate optima parse-declarations-1.0
     symbol-munger)
    VERSION 20211230-git SIBLINGS NIL PARASITES (cl-form-types/test)) */
