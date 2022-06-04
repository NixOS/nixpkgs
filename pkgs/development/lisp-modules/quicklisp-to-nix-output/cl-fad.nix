/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-fad";
  version = "20220220-git";

  parasites = [ "cl-fad/test" ];

  description = "Portable pathname library";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-ppcre" args."unit-test" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-fad/2022-02-20/cl-fad-20220220-git.tgz";
    sha256 = "09229w4rr2lg4y8244w5170i1znmc2svbn6n8s39ndhdnw0akyli";
  };

  packageName = "cl-fad";

  asdFilesToKeep = ["cl-fad.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fad DESCRIPTION Portable pathname library SHA256
    09229w4rr2lg4y8244w5170i1znmc2svbn6n8s39ndhdnw0akyli URL
    http://beta.quicklisp.org/archive/cl-fad/2022-02-20/cl-fad-20220220-git.tgz
    MD5 5caa98f5badf1d84ae385a3937ee2e01 NAME cl-fad FILENAME cl-fad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME unit-test FILENAME unit-test))
    DEPENDENCIES (alexandria bordeaux-threads cl-ppcre unit-test) VERSION
    20220220-git SIBLINGS NIL PARASITES (cl-fad/test)) */
