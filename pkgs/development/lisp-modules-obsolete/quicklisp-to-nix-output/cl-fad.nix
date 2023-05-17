/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-fad";
  version = "20210124-git";

  parasites = [ "cl-fad-test" ];

  description = "Portable pathname library";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-ppcre" args."unit-test" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-fad/2021-01-24/cl-fad-20210124-git.tgz";
    sha256 = "17vkvkwg4wpyny5x2nsazgpip5nxxahsjngaxjyrj5z15d4lkrm0";
  };

  packageName = "cl-fad";

  asdFilesToKeep = ["cl-fad.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fad DESCRIPTION Portable pathname library SHA256
    17vkvkwg4wpyny5x2nsazgpip5nxxahsjngaxjyrj5z15d4lkrm0 URL
    http://beta.quicklisp.org/archive/cl-fad/2021-01-24/cl-fad-20210124-git.tgz
    MD5 aa8705a0dd8ca1b43d8c76a177efdf74 NAME cl-fad FILENAME cl-fad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME unit-test FILENAME unit-test))
    DEPENDENCIES (alexandria bordeaux-threads cl-ppcre unit-test) VERSION
    20210124-git SIBLINGS NIL PARASITES (cl-fad-test)) */
