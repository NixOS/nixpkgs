/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-typesetting";
  version = "20210228-git";

  description = "Common Lisp Typesetting system";

  deps = [ args."cl-pdf" args."iterate" args."zpb-ttf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-typesetting/2021-02-28/cl-typesetting-20210228-git.tgz";
    sha256 = "13rmzyzp0glq35jq3qdlmrsdssa6csqp5g455li4wi7kq8clrwnp";
  };

  packageName = "cl-typesetting";

  asdFilesToKeep = ["cl-typesetting.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-typesetting DESCRIPTION Common Lisp Typesetting system SHA256
    13rmzyzp0glq35jq3qdlmrsdssa6csqp5g455li4wi7kq8clrwnp URL
    http://beta.quicklisp.org/archive/cl-typesetting/2021-02-28/cl-typesetting-20210228-git.tgz
    MD5 949e7de37838d63f4c6b6e7dd88befeb NAME cl-typesetting FILENAME
    cl-typesetting DEPS
    ((NAME cl-pdf FILENAME cl-pdf) (NAME iterate FILENAME iterate)
     (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (cl-pdf iterate zpb-ttf) VERSION 20210228-git SIBLINGS
    (xml-render cl-pdf-doc) PARASITES NIL) */
