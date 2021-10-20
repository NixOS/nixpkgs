/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-form-types";
  version = "20210807-git";

  parasites = [ "cl-form-types/test" ];

  description = "Library for determining types of Common Lisp forms.";

  deps = [ args."agutil" args."alexandria" args."anaphora" args."arrows" args."cl-environments" args."closer-mop" args."collectors" args."fiveam" args."introspect-environment" args."iterate" args."optima" args."parse-declarations-1_dot_0" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-form-types/2021-08-07/cl-form-types-20210807-git.tgz";
    sha256 = "1hv78ygnzf67f8ww22bmc2nx2gmw3lg7qc3navmd541jivx6v0lp";
  };

  packageName = "cl-form-types";

  asdFilesToKeep = ["cl-form-types.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-form-types DESCRIPTION
    Library for determining types of Common Lisp forms. SHA256
    1hv78ygnzf67f8ww22bmc2nx2gmw3lg7qc3navmd541jivx6v0lp URL
    http://beta.quicklisp.org/archive/cl-form-types/2021-08-07/cl-form-types-20210807-git.tgz
    MD5 1b1415794a4e9cd6716ee3b5eb0f658a NAME cl-form-types FILENAME
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
    VERSION 20210807-git SIBLINGS NIL PARASITES (cl-form-types/test)) */
