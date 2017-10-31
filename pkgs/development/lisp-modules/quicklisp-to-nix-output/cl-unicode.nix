args @ { fetchurl, ... }:
rec {
  baseName = ''cl-unicode'';
  version = ''0.1.5'';

  parasites = [ "cl-unicode/base" "cl-unicode/build" "cl-unicode/test" ];

  description = ''Portable Unicode Library'';

  deps = [ args."cl-ppcre" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unicode/2014-12-17/cl-unicode-0.1.5.tgz'';
    sha256 = ''1jd5qq5ji6l749c4x415z22y9r0k9z18pdi9p9fqvamzh854i46n'';
  };

  packageName = "cl-unicode";

  asdFilesToKeep = ["cl-unicode.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-unicode DESCRIPTION Portable Unicode Library SHA256
    1jd5qq5ji6l749c4x415z22y9r0k9z18pdi9p9fqvamzh854i46n URL
    http://beta.quicklisp.org/archive/cl-unicode/2014-12-17/cl-unicode-0.1.5.tgz
    MD5 2fd456537bd670126da84466226bc5c5 NAME cl-unicode FILENAME cl-unicode
    DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre flexi-streams) VERSION 0.1.5 SIBLINGS NIL PARASITES
    (cl-unicode/base cl-unicode/build cl-unicode/test)) */
