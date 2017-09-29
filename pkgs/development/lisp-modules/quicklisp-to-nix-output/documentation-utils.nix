args @ { fetchurl, ... }:
rec {
  baseName = ''documentation-utils'';
  version = ''20170630-git'';

  description = ''A few simple tools to help you with documenting your library.'';

  deps = [ args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/documentation-utils/2017-06-30/documentation-utils-20170630-git.tgz'';
    sha256 = ''0iz3r5llv0rv8l37fdcjrx9zibbaqf9nd6xhy5n2hf024997bbks'';
  };

  packageName = "documentation-utils";

  asdFilesToKeep = ["documentation-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM documentation-utils DESCRIPTION
    A few simple tools to help you with documenting your library. SHA256
    0iz3r5llv0rv8l37fdcjrx9zibbaqf9nd6xhy5n2hf024997bbks URL
    http://beta.quicklisp.org/archive/documentation-utils/2017-06-30/documentation-utils-20170630-git.tgz
    MD5 7c0541d4207ba221a251c8c3ec7a8cac NAME documentation-utils FILENAME
    documentation-utils DEPS ((NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (trivial-indent) VERSION 20170630-git SIBLINGS NIL PARASITES
    NIL) */
