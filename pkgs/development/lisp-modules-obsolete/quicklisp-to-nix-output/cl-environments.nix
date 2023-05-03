/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-environments";
  version = "20211020-git";

  parasites = [ "cl-environments/test" ];

  description = "Implements the CLTL2 environment access functionality
                for implementations which do not provide the
                functionality to the programmer.";

  deps = [ args."alexandria" args."anaphora" args."closer-mop" args."collectors" args."fiveam" args."iterate" args."optima" args."parse-declarations-1_dot_0" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-environments/2021-10-20/cl-environments-20211020-git.tgz";
    sha256 = "0aryb40nmmw34xl6h0fp8i43d2x7zlwysim365c171mcyxh3w9lr";
  };

  packageName = "cl-environments";

  asdFilesToKeep = ["cl-environments.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-environments DESCRIPTION
    Implements the CLTL2 environment access functionality
                for implementations which do not provide the
                functionality to the programmer.
    SHA256 0aryb40nmmw34xl6h0fp8i43d2x7zlwysim365c171mcyxh3w9lr URL
    http://beta.quicklisp.org/archive/cl-environments/2021-10-20/cl-environments-20211020-git.tgz
    MD5 a796decf21a5b595ff591ffca378994a NAME cl-environments FILENAME
    cl-environments DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME closer-mop FILENAME closer-mop)
     (NAME collectors FILENAME collectors) (NAME fiveam FILENAME fiveam)
     (NAME iterate FILENAME iterate) (NAME optima FILENAME optima)
     (NAME parse-declarations-1.0 FILENAME parse-declarations-1_dot_0)
     (NAME symbol-munger FILENAME symbol-munger))
    DEPENDENCIES
    (alexandria anaphora closer-mop collectors fiveam iterate optima
     parse-declarations-1.0 symbol-munger)
    VERSION 20211020-git SIBLINGS NIL PARASITES (cl-environments/test)) */
