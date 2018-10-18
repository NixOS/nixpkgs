args @ { fetchurl, ... }:
rec {
  baseName = ''cl-interpol'';
  version = ''20180711-git'';

  parasites = [ "cl-interpol-test" ];

  description = '''';

  deps = [ args."cl-ppcre" args."cl-unicode" args."flexi-streams" args."named-readtables" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-interpol/2018-07-11/cl-interpol-20180711-git.tgz'';
    sha256 = ''1s88m5kci9y9h3ycvqm0xjzbkbd8zhm9rxp2a674hmgrjfqras0r'';
  };

  packageName = "cl-interpol";

  asdFilesToKeep = ["cl-interpol.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-interpol DESCRIPTION NIL SHA256
    1s88m5kci9y9h3ycvqm0xjzbkbd8zhm9rxp2a674hmgrjfqras0r URL
    http://beta.quicklisp.org/archive/cl-interpol/2018-07-11/cl-interpol-20180711-git.tgz
    MD5 b2d6893ef703c5b6e5736fa33ba0794e NAME cl-interpol FILENAME cl-interpol
    DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME named-readtables FILENAME named-readtables))
    DEPENDENCIES (cl-ppcre cl-unicode flexi-streams named-readtables) VERSION
    20180711-git SIBLINGS NIL PARASITES (cl-interpol-test)) */
