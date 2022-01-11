/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "data-frame";
  version = "20210411-git";

  parasites = [ "data-frame/tests" ];

  description = "Data frames for Common Lisp";

  deps = [ args."alexandria" args."anaphora" args."array-operations" args."clunit" args."let-plus" args."num-utils" args."select" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/data-frame/2021-04-11/data-frame-20210411-git.tgz";
    sha256 = "1ycpbhzkc54x4mvghq6ss6s9ya1zn1s6d0cifh20c3b9kfca1xgv";
  };

  packageName = "data-frame";

  asdFilesToKeep = ["data-frame.asd"];
  overrides = x: x;
}
/* (SYSTEM data-frame DESCRIPTION Data frames for Common Lisp SHA256
    1ycpbhzkc54x4mvghq6ss6s9ya1zn1s6d0cifh20c3b9kfca1xgv URL
    http://beta.quicklisp.org/archive/data-frame/2021-04-11/data-frame-20210411-git.tgz
    MD5 b376dd3510b55efe93cbcbf8478f94ed NAME data-frame FILENAME data-frame
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME array-operations FILENAME array-operations)
     (NAME clunit FILENAME clunit) (NAME let-plus FILENAME let-plus)
     (NAME num-utils FILENAME num-utils) (NAME select FILENAME select))
    DEPENDENCIES
    (alexandria anaphora array-operations clunit let-plus num-utils select)
    VERSION 20210411-git SIBLINGS NIL PARASITES (data-frame/tests)) */
