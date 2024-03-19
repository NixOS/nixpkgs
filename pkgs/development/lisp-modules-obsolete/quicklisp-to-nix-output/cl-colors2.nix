/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-colors2";
  version = "20211020-git";

  parasites = [ "cl-colors2/tests" ];

  description = "Simple color library for Common Lisp";

  deps = [ args."alexandria" args."cl-ppcre" args."clunit2" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-colors2/2021-10-20/cl-colors2-20211020-git.tgz";
    sha256 = "1vkhcyflp173szwnd1xg7hk0h1f3144qzwnsdv6a16rlxjz9h804";
  };

  packageName = "cl-colors2";

  asdFilesToKeep = ["cl-colors2.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-colors2 DESCRIPTION Simple color library for Common Lisp SHA256
    1vkhcyflp173szwnd1xg7hk0h1f3144qzwnsdv6a16rlxjz9h804 URL
    http://beta.quicklisp.org/archive/cl-colors2/2021-10-20/cl-colors2-20211020-git.tgz
    MD5 13fd422daa03328c909d1578d65f6222 NAME cl-colors2 FILENAME cl-colors2
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clunit2 FILENAME clunit2))
    DEPENDENCIES (alexandria cl-ppcre clunit2) VERSION 20211020-git SIBLINGS
    NIL PARASITES (cl-colors2/tests)) */
