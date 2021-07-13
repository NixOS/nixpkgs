/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-typesetting";
  version = "20210411-git";

  description = "Common Lisp Typesetting system";

  deps = [ args."cl-pdf" args."iterate" args."zpb-ttf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-typesetting/2021-04-11/cl-typesetting-20210411-git.tgz";
    sha256 = "1102n049hhg0kqnfvdfcisjq5l9yfvbw090nq0q8vd2bc688ng41";
  };

  packageName = "cl-typesetting";

  asdFilesToKeep = ["cl-typesetting.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-typesetting DESCRIPTION Common Lisp Typesetting system SHA256
    1102n049hhg0kqnfvdfcisjq5l9yfvbw090nq0q8vd2bc688ng41 URL
    http://beta.quicklisp.org/archive/cl-typesetting/2021-04-11/cl-typesetting-20210411-git.tgz
    MD5 f3fc7a47efb99cf849cb5eeede96dbaf NAME cl-typesetting FILENAME
    cl-typesetting DEPS
    ((NAME cl-pdf FILENAME cl-pdf) (NAME iterate FILENAME iterate)
     (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (cl-pdf iterate zpb-ttf) VERSION 20210411-git SIBLINGS
    (xml-render cl-pdf-doc) PARASITES NIL) */
