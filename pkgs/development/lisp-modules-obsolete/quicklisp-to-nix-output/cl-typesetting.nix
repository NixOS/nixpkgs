/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-typesetting";
  version = "20210531-git";

  description = "Common Lisp Typesetting system";

  deps = [ args."cl-pdf" args."iterate" args."zpb-ttf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-typesetting/2021-05-31/cl-typesetting-20210531-git.tgz";
    sha256 = "1gv21dsfghf8y2d7f5w5m8fn0q5l7xb8z7qw11wnnnd7msk11dd5";
  };

  packageName = "cl-typesetting";

  asdFilesToKeep = ["cl-typesetting.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-typesetting DESCRIPTION Common Lisp Typesetting system SHA256
    1gv21dsfghf8y2d7f5w5m8fn0q5l7xb8z7qw11wnnnd7msk11dd5 URL
    http://beta.quicklisp.org/archive/cl-typesetting/2021-05-31/cl-typesetting-20210531-git.tgz
    MD5 849e6fb2c4a33f823c005e4e9abb31b5 NAME cl-typesetting FILENAME
    cl-typesetting DEPS
    ((NAME cl-pdf FILENAME cl-pdf) (NAME iterate FILENAME iterate)
     (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (cl-pdf iterate zpb-ttf) VERSION 20210531-git SIBLINGS
    (xml-render cl-pdf-doc) PARASITES NIL) */
