args @ { fetchurl, ... }:
{
  baseName = ''cl-unicode'';
  version = ''20190521-git'';

  parasites = [ "cl-unicode/base" "cl-unicode/build" "cl-unicode/test" ];

  description = ''Portable Unicode Library'';

  deps = [ args."cl-ppcre" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unicode/2019-05-21/cl-unicode-20190521-git.tgz'';
    sha256 = ''0p20yrqbn3fwsnrxvh2cv0m86mh3mz9vj15m7siw1kjkbzq0vngc'';
  };

  packageName = "cl-unicode";

  asdFilesToKeep = ["cl-unicode.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-unicode DESCRIPTION Portable Unicode Library SHA256
    0p20yrqbn3fwsnrxvh2cv0m86mh3mz9vj15m7siw1kjkbzq0vngc URL
    http://beta.quicklisp.org/archive/cl-unicode/2019-05-21/cl-unicode-20190521-git.tgz
    MD5 04009a1266edbdda4d38902907caba25 NAME cl-unicode FILENAME cl-unicode
    DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre flexi-streams) VERSION 20190521-git SIBLINGS NIL
    PARASITES (cl-unicode/base cl-unicode/build cl-unicode/test)) */
