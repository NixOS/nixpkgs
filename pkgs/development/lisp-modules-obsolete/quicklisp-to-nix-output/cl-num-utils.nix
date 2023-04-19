/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-num-utils";
  version = "20210531-git";

  parasites = [ "cl-num-utils-tests" ];

  description = "Numerical utilities for Common Lisp";

  deps = [ args."alexandria" args."anaphora" args."array-operations" args."cl-slice" args."clunit" args."let-plus" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-num-utils/2021-05-31/cl-num-utils-20210531-git.tgz";
    sha256 = "1snhwhnrkmavkhwd0dx7a958xdiwcc0a84fj0k5xqj99ksd9hp8x";
  };

  packageName = "cl-num-utils";

  asdFilesToKeep = ["cl-num-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-num-utils DESCRIPTION Numerical utilities for Common Lisp SHA256
    1snhwhnrkmavkhwd0dx7a958xdiwcc0a84fj0k5xqj99ksd9hp8x URL
    http://beta.quicklisp.org/archive/cl-num-utils/2021-05-31/cl-num-utils-20210531-git.tgz
    MD5 1977251bf552ba82005de0dc2f37d130 NAME cl-num-utils FILENAME
    cl-num-utils DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME array-operations FILENAME array-operations)
     (NAME cl-slice FILENAME cl-slice) (NAME clunit FILENAME clunit)
     (NAME let-plus FILENAME let-plus))
    DEPENDENCIES
    (alexandria anaphora array-operations cl-slice clunit let-plus) VERSION
    20210531-git SIBLINGS NIL PARASITES (cl-num-utils-tests)) */
