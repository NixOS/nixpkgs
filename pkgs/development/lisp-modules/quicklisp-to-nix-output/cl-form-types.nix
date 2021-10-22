/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-form-types";
  version = "20211020-git";

  parasites = [ "cl-form-types/test" ];

  description = "Library for determining types of Common Lisp forms.";

  deps = [ args."agutil" args."alexandria" args."anaphora" args."arrows" args."cl-environments" args."closer-mop" args."collectors" args."fiveam" args."introspect-environment" args."iterate" args."optima" args."parse-declarations-1_dot_0" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-form-types/2021-10-20/cl-form-types-20211020-git.tgz";
    sha256 = "1f5wni1jrd5jbra2z2smw4vdw4k3bkbas8n676y3g3yv10lhddg8";
  };

  packageName = "cl-form-types";

  asdFilesToKeep = ["cl-form-types.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-form-types DESCRIPTION
    Library for determining types of Common Lisp forms. SHA256
    1f5wni1jrd5jbra2z2smw4vdw4k3bkbas8n676y3g3yv10lhddg8 URL
    http://beta.quicklisp.org/archive/cl-form-types/2021-10-20/cl-form-types-20211020-git.tgz
    MD5 53e67d9fd55ac6a382635b119aeb5431 NAME cl-form-types FILENAME
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
    VERSION 20211020-git SIBLINGS NIL PARASITES (cl-form-types/test)) */
