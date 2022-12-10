/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-ansi-text";
  version = "20211020-git";

  description = "ANSI control string characters, focused on color";

  deps = [ args."alexandria" args."cl-colors2" args."cl-ppcre" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-ansi-text/2021-10-20/cl-ansi-text-20211020-git.tgz";
    sha256 = "1lmxmdf4sm7apkczp0y07rlsayc5adyv2i85r6p7s60w6sianjr6";
  };

  packageName = "cl-ansi-text";

  asdFilesToKeep = ["cl-ansi-text.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ansi-text DESCRIPTION
    ANSI control string characters, focused on color SHA256
    1lmxmdf4sm7apkczp0y07rlsayc5adyv2i85r6p7s60w6sianjr6 URL
    http://beta.quicklisp.org/archive/cl-ansi-text/2021-10-20/cl-ansi-text-20211020-git.tgz
    MD5 5411766beeb4180218b449454b67837f NAME cl-ansi-text FILENAME
    cl-ansi-text DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-colors2 FILENAME cl-colors2) (NAME cl-ppcre FILENAME cl-ppcre))
    DEPENDENCIES (alexandria cl-colors2 cl-ppcre) VERSION 20211020-git SIBLINGS
    (cl-ansi-text.test) PARASITES NIL) */
