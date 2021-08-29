/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-colors2";
  version = "20210411-git";

  parasites = [ "cl-colors2/tests" ];

  description = "Simple color library for Common Lisp";

  deps = [ args."alexandria" args."cl-ppcre" args."clunit2" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-colors2/2021-04-11/cl-colors2-20210411-git.tgz";
    sha256 = "14kdi214x8rxil27wfbx0csgi7g8dg5wsifpsrdrqph0p7ps8snk";
  };

  packageName = "cl-colors2";

  asdFilesToKeep = ["cl-colors2.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-colors2 DESCRIPTION Simple color library for Common Lisp SHA256
    14kdi214x8rxil27wfbx0csgi7g8dg5wsifpsrdrqph0p7ps8snk URL
    http://beta.quicklisp.org/archive/cl-colors2/2021-04-11/cl-colors2-20210411-git.tgz
    MD5 e6b54e76e7d1cfcff45955dbd4752f1d NAME cl-colors2 FILENAME cl-colors2
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clunit2 FILENAME clunit2))
    DEPENDENCIES (alexandria cl-ppcre clunit2) VERSION 20210411-git SIBLINGS
    NIL PARASITES (cl-colors2/tests)) */
