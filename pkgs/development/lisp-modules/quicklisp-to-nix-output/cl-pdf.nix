args @ { fetchurl, ... }:
rec {
  baseName = ''cl-pdf'';
  version = ''20170830-git'';

  description = ''Common Lisp PDF Generation Library'';

  deps = [ args."iterate" args."uiop" args."zpb-ttf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-pdf/2017-08-30/cl-pdf-20170830-git.tgz'';
    sha256 = ''1x4zk6l635f121p1anfd7d807iglyrlhsnmygydw5l49m3h6n08s'';
  };

  packageName = "cl-pdf";

  asdFilesToKeep = ["cl-pdf.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-pdf DESCRIPTION Common Lisp PDF Generation Library SHA256
    1x4zk6l635f121p1anfd7d807iglyrlhsnmygydw5l49m3h6n08s URL
    http://beta.quicklisp.org/archive/cl-pdf/2017-08-30/cl-pdf-20170830-git.tgz
    MD5 f865503aff50c0a4732a7a4597bdcc25 NAME cl-pdf FILENAME cl-pdf DEPS
    ((NAME iterate FILENAME iterate) (NAME uiop FILENAME uiop)
     (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (iterate uiop zpb-ttf) VERSION 20170830-git SIBLINGS
    (cl-pdf-parser) PARASITES NIL) */
