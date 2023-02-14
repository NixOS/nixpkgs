/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-pdf";
  version = "20220220-git";

  description = "Common Lisp PDF Generation Library";

  deps = [ args."iterate" args."uiop" args."zpb-ttf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-pdf/2022-02-20/cl-pdf-20220220-git.tgz";
    sha256 = "0a0d3jdvrcjxjwajkfr6iz8xmbk6yri7zcnv5gjnldpn0f4iv1l0";
  };

  packageName = "cl-pdf";

  asdFilesToKeep = ["cl-pdf.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-pdf DESCRIPTION Common Lisp PDF Generation Library SHA256
    0a0d3jdvrcjxjwajkfr6iz8xmbk6yri7zcnv5gjnldpn0f4iv1l0 URL
    http://beta.quicklisp.org/archive/cl-pdf/2022-02-20/cl-pdf-20220220-git.tgz
    MD5 e613e178e3a3a879037f441841ca5aa4 NAME cl-pdf FILENAME cl-pdf DEPS
    ((NAME iterate FILENAME iterate) (NAME uiop FILENAME uiop)
     (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (iterate uiop zpb-ttf) VERSION 20220220-git SIBLINGS
    (cl-pdf-parser) PARASITES NIL) */
