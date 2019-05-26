args @ { fetchurl, ... }:
rec {
  baseName = ''cl-unicode'';
  version = ''20180328-git'';

  parasites = [ "cl-unicode/base" "cl-unicode/build" "cl-unicode/test" ];

  description = ''Portable Unicode Library'';

  deps = [ args."cl-ppcre" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unicode/2018-03-28/cl-unicode-20180328-git.tgz'';
    sha256 = ''1ky8qhvisagyvd7qcqzvy40z2sl9dr16q94k21wpgpvlz3kwbpln'';
  };

  packageName = "cl-unicode";

  asdFilesToKeep = ["cl-unicode.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-unicode DESCRIPTION Portable Unicode Library SHA256
    1ky8qhvisagyvd7qcqzvy40z2sl9dr16q94k21wpgpvlz3kwbpln URL
    http://beta.quicklisp.org/archive/cl-unicode/2018-03-28/cl-unicode-20180328-git.tgz
    MD5 6030b7833f08f78946ddd44d6c6a9086 NAME cl-unicode FILENAME cl-unicode
    DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre flexi-streams) VERSION 20180328-git SIBLINGS NIL
    PARASITES (cl-unicode/base cl-unicode/build cl-unicode/test)) */
