/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "array-operations";
  version = "20210411-git";

  parasites = [ "array-operations/tests" ];

  description = "Simple array operations library for Common Lisp.";

  deps = [ args."alexandria" args."anaphora" args."clunit2" args."let-plus" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/array-operations/2021-04-11/array-operations-20210411-git.tgz";
    sha256 = "0l6wxd3a1xdcmcsc93prq8ymainfsy15imiwnaik1i9g94fcbjz8";
  };

  packageName = "array-operations";

  asdFilesToKeep = ["array-operations.asd"];
  overrides = x: x;
}
/* (SYSTEM array-operations DESCRIPTION
    Simple array operations library for Common Lisp. SHA256
    0l6wxd3a1xdcmcsc93prq8ymainfsy15imiwnaik1i9g94fcbjz8 URL
    http://beta.quicklisp.org/archive/array-operations/2021-04-11/array-operations-20210411-git.tgz
    MD5 902c6034c006bc6ca88ef59e7ff2b1aa NAME array-operations FILENAME
    array-operations DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME clunit2 FILENAME clunit2) (NAME let-plus FILENAME let-plus))
    DEPENDENCIES (alexandria anaphora clunit2 let-plus) VERSION 20210411-git
    SIBLINGS NIL PARASITES (array-operations/tests)) */
