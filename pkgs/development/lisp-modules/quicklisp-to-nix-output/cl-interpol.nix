args @ { fetchurl, ... }:
rec {
  baseName = ''cl-interpol'';
  version = ''20200715-git'';

  parasites = [ "cl-interpol-test" ];

  description = ''System lacks description'';

  deps = [ args."cl-ppcre" args."cl-unicode" args."flexi-streams" args."named-readtables" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-interpol/2020-07-15/cl-interpol-20200715-git.tgz'';
    sha256 = ''0qbmpgnlg9y6ykwahmw1q8b058krmcq47w3gx75xz920im46wvmw'';
  };

  packageName = "cl-interpol";

  asdFilesToKeep = ["cl-interpol.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-interpol DESCRIPTION System lacks description SHA256
    0qbmpgnlg9y6ykwahmw1q8b058krmcq47w3gx75xz920im46wvmw URL
    http://beta.quicklisp.org/archive/cl-interpol/2020-07-15/cl-interpol-20200715-git.tgz
    MD5 24a2c8907e35e0a276c37c4b1999681c NAME cl-interpol FILENAME cl-interpol
    DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME named-readtables FILENAME named-readtables))
    DEPENDENCIES (cl-ppcre cl-unicode flexi-streams named-readtables) VERSION
    20200715-git SIBLINGS NIL PARASITES (cl-interpol-test)) */
