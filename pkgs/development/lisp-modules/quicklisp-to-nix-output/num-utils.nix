/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "num-utils";
  version = "numerical-utilities-20210411-git";

  parasites = [ "num-utils/tests" ];

  description = "Numerical utilities for Common Lisp";

  deps = [ args."alexandria" args."anaphora" args."array-operations" args."fiveam" args."let-plus" args."select" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/numerical-utilities/2021-04-11/numerical-utilities-20210411-git.tgz";
    sha256 = "19d1vm9hasgba9l2mwby8izd7pzmisckf52h6fmh170lwkqixqxb";
  };

  packageName = "num-utils";

  asdFilesToKeep = ["num-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM num-utils DESCRIPTION Numerical utilities for Common Lisp SHA256
    19d1vm9hasgba9l2mwby8izd7pzmisckf52h6fmh170lwkqixqxb URL
    http://beta.quicklisp.org/archive/numerical-utilities/2021-04-11/numerical-utilities-20210411-git.tgz
    MD5 87fac84d7897071bfa89fc9aeca7b4d0 NAME num-utils FILENAME num-utils DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME array-operations FILENAME array-operations)
     (NAME fiveam FILENAME fiveam) (NAME let-plus FILENAME let-plus)
     (NAME select FILENAME select))
    DEPENDENCIES (alexandria anaphora array-operations fiveam let-plus select)
    VERSION numerical-utilities-20210411-git SIBLINGS NIL PARASITES
    (num-utils/tests)) */
