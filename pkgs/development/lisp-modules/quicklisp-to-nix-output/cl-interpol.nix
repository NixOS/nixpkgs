args @ { fetchurl, ... }:
rec {
  baseName = ''cl-interpol'';
  version = ''0.2.6'';

  parasites = [ "cl-interpol-test" ];

  description = '''';

  deps = [ args."cl-ppcre" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-interpol/2016-09-29/cl-interpol-0.2.6.tgz'';
    sha256 = ''172iy4bp4fxyfhz7n6jbqz4j8xqnzpvmh981bbi5waflg58x9h8b'';
  };

  packageName = "cl-interpol";

  asdFilesToKeep = ["cl-interpol.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-interpol DESCRIPTION NIL SHA256
    172iy4bp4fxyfhz7n6jbqz4j8xqnzpvmh981bbi5waflg58x9h8b URL
    http://beta.quicklisp.org/archive/cl-interpol/2016-09-29/cl-interpol-0.2.6.tgz
    MD5 1adc92924670601ebb92546ef8bdc6a7 NAME cl-interpol FILENAME cl-interpol
    DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre cl-unicode flexi-streams) VERSION 0.2.6 SIBLINGS NIL
    PARASITES (cl-interpol-test)) */
