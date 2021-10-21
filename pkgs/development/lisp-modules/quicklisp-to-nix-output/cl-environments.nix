/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-environments";
  version = "20210807-git";

  parasites = [ "cl-environments/test" ];

  description = "Implements the CLTL2 environment access functionality
                for implementations which do not provide the
                functionality to the programmer.";

  deps = [ args."alexandria" args."anaphora" args."closer-mop" args."collectors" args."fiveam" args."iterate" args."optima" args."parse-declarations-1_dot_0" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-environments/2021-08-07/cl-environments-20210807-git.tgz";
    sha256 = "1i544zz9v49b0mdv96sr17ivnz4s84lgw4vypq9v9w6cmhz5v8am";
  };

  packageName = "cl-environments";

  asdFilesToKeep = ["cl-environments.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-environments DESCRIPTION
    Implements the CLTL2 environment access functionality
                for implementations which do not provide the
                functionality to the programmer.
    SHA256 1i544zz9v49b0mdv96sr17ivnz4s84lgw4vypq9v9w6cmhz5v8am URL
    http://beta.quicklisp.org/archive/cl-environments/2021-08-07/cl-environments-20210807-git.tgz
    MD5 6884f21f315c5082fd6db7233497497d NAME cl-environments FILENAME
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
    VERSION 20210807-git SIBLINGS NIL PARASITES (cl-environments/test)) */
