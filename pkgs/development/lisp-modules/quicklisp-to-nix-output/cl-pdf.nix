args @ { fetchurl, ... }:
rec {
  baseName = ''cl-pdf'';
  version = ''20191007-git'';

  description = ''Common Lisp PDF Generation Library'';

  deps = [ args."iterate" args."uiop" args."zpb-ttf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-pdf/2019-10-07/cl-pdf-20191007-git.tgz'';
    sha256 = ''0l0hnxysy7dc4wj50nfwn8x7v188vaxvsvk8kl92zb92lfzgw7cd'';
  };

  packageName = "cl-pdf";

  asdFilesToKeep = ["cl-pdf.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-pdf DESCRIPTION Common Lisp PDF Generation Library SHA256
    0l0hnxysy7dc4wj50nfwn8x7v188vaxvsvk8kl92zb92lfzgw7cd URL
    http://beta.quicklisp.org/archive/cl-pdf/2019-10-07/cl-pdf-20191007-git.tgz
    MD5 edde2f2da08ec10be65364737ed5fa5c NAME cl-pdf FILENAME cl-pdf DEPS
    ((NAME iterate FILENAME iterate) (NAME uiop FILENAME uiop)
     (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (iterate uiop zpb-ttf) VERSION 20191007-git SIBLINGS
    (cl-pdf-parser) PARASITES NIL) */
