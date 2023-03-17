/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-form-types";
  version = "20211209-git";

  parasites = [ "cl-form-types/test" ];

  description = "Library for determining types of Common Lisp forms.";

  deps = [ args."agutil" args."alexandria" args."anaphora" args."arrows" args."cl-environments" args."closer-mop" args."collectors" args."fiveam" args."introspect-environment" args."iterate" args."optima" args."parse-declarations-1_dot_0" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-form-types/2021-12-09/cl-form-types-20211209-git.tgz";
    sha256 = "1w1918a9rjw9dp5qpwq3mf0p4yyd2xladnd6sz4zk645y7wxd08i";
  };

  packageName = "cl-form-types";

  asdFilesToKeep = ["cl-form-types.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-form-types DESCRIPTION
    Library for determining types of Common Lisp forms. SHA256
    1w1918a9rjw9dp5qpwq3mf0p4yyd2xladnd6sz4zk645y7wxd08i URL
    http://beta.quicklisp.org/archive/cl-form-types/2021-12-09/cl-form-types-20211209-git.tgz
    MD5 2c128061c2e8a97b70fbf8939708d53e NAME cl-form-types FILENAME
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
    VERSION 20211209-git SIBLINGS NIL PARASITES (cl-form-types/test)) */
