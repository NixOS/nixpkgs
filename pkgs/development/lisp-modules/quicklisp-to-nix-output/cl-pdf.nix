/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-pdf";
  version = "20210228-git";

  description = "Common Lisp PDF Generation Library";

  deps = [ args."iterate" args."uiop" args."zpb-ttf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-pdf/2021-02-28/cl-pdf-20210228-git.tgz";
    sha256 = "1m1nq91p49gfc9iccja2wbhglrv0mgzhqvliss7jr0j6icv66x3y";
  };

  packageName = "cl-pdf";

  asdFilesToKeep = ["cl-pdf.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-pdf DESCRIPTION Common Lisp PDF Generation Library SHA256
    1m1nq91p49gfc9iccja2wbhglrv0mgzhqvliss7jr0j6icv66x3y URL
    http://beta.quicklisp.org/archive/cl-pdf/2021-02-28/cl-pdf-20210228-git.tgz
    MD5 a0eae40821642fc5287b67bf462b54d9 NAME cl-pdf FILENAME cl-pdf DEPS
    ((NAME iterate FILENAME iterate) (NAME uiop FILENAME uiop)
     (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (iterate uiop zpb-ttf) VERSION 20210228-git SIBLINGS
    (cl-pdf-parser) PARASITES NIL) */
