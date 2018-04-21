args @ { fetchurl, ... }:
rec {
  baseName = ''documentation-utils'';
  version = ''20180131-git'';

  description = ''A few simple tools to help you with documenting your library.'';

  deps = [ args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/documentation-utils/2018-01-31/documentation-utils-20180131-git.tgz'';
    sha256 = ''0kyxjcl7dvylymzvmrn90kdwaxgrzyzpi1mqpirsr3yyb8h71avm'';
  };

  packageName = "documentation-utils";

  asdFilesToKeep = ["documentation-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM documentation-utils DESCRIPTION
    A few simple tools to help you with documenting your library. SHA256
    0kyxjcl7dvylymzvmrn90kdwaxgrzyzpi1mqpirsr3yyb8h71avm URL
    http://beta.quicklisp.org/archive/documentation-utils/2018-01-31/documentation-utils-20180131-git.tgz
    MD5 375dbb8ce48543fce1526eeea8d2a976 NAME documentation-utils FILENAME
    documentation-utils DEPS ((NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (trivial-indent) VERSION 20180131-git SIBLINGS NIL PARASITES
    NIL) */
