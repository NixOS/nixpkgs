args @ { fetchurl, ... }:
rec {
  baseName = ''cl-typesetting'';
  version = ''20170830-git'';

  description = ''Common Lisp Typesetting system'';

  deps = [ args."cl-pdf" args."iterate" args."zpb-ttf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-typesetting/2017-08-30/cl-typesetting-20170830-git.tgz'';
    sha256 = ''1mkdr02qikzij3jiyrqy0dldzy8wsnvgcpznfha6x8p2xap586z3'';
  };

  packageName = "cl-typesetting";

  asdFilesToKeep = ["cl-typesetting.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-typesetting DESCRIPTION Common Lisp Typesetting system SHA256
    1mkdr02qikzij3jiyrqy0dldzy8wsnvgcpznfha6x8p2xap586z3 URL
    http://beta.quicklisp.org/archive/cl-typesetting/2017-08-30/cl-typesetting-20170830-git.tgz
    MD5 e12b9f249c60c220c5dc4a0939eb3343 NAME cl-typesetting FILENAME
    cl-typesetting DEPS
    ((NAME cl-pdf FILENAME cl-pdf) (NAME iterate FILENAME iterate)
     (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (cl-pdf iterate zpb-ttf) VERSION 20170830-git SIBLINGS
    (xml-render cl-pdf-doc) PARASITES NIL) */
