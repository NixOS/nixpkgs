/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-pdf";
  version = "20210531-git";

  description = "Common Lisp PDF Generation Library";

  deps = [ args."iterate" args."uiop" args."zpb-ttf" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-pdf/2021-05-31/cl-pdf-20210531-git.tgz";
    sha256 = "0f5flqci615ck0ncq4f7x67x31m9715750r0wg3gx6qrdpi0k1cx";
  };

  packageName = "cl-pdf";

  asdFilesToKeep = ["cl-pdf.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-pdf DESCRIPTION Common Lisp PDF Generation Library SHA256
    0f5flqci615ck0ncq4f7x67x31m9715750r0wg3gx6qrdpi0k1cx URL
    http://beta.quicklisp.org/archive/cl-pdf/2021-05-31/cl-pdf-20210531-git.tgz
    MD5 675d3498976f4cb118dc72fa71829f5c NAME cl-pdf FILENAME cl-pdf DEPS
    ((NAME iterate FILENAME iterate) (NAME uiop FILENAME uiop)
     (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES (iterate uiop zpb-ttf) VERSION 20210531-git SIBLINGS
    (cl-pdf-parser) PARASITES NIL) */
