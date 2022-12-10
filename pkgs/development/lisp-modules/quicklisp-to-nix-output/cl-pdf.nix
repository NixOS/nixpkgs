/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-pdf";
  version = "20211020-git";

  description = "Common Lisp PDF Generation Library";

  deps = [ args."iterate" args."uiop" args."zpb-ttf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-pdf/2021-10-20/cl-pdf-20211020-git.tgz";
    sha256 = "0wyh7iv86sqzdn5xj5crrip8iri5a64qzc6cczgbj1gkv65i28bk";
  };

  packageName = "cl-pdf";

  asdFilesToKeep = ["cl-pdf.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-pdf DESCRIPTION Common Lisp PDF Generation Library SHA256
    0wyh7iv86sqzdn5xj5crrip8iri5a64qzc6cczgbj1gkv65i28bk URL
    http://beta.quicklisp.org/archive/cl-pdf/2021-10-20/cl-pdf-20211020-git.tgz
    MD5 c8a9cfd5d65eae217bd55d786d31dca9 NAME cl-pdf FILENAME cl-pdf DEPS
    ((NAME iterate FILENAME iterate) (NAME uiop FILENAME uiop)
     (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (iterate uiop zpb-ttf) VERSION 20211020-git SIBLINGS
    (cl-pdf-parser) PARASITES NIL) */
