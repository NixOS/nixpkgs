args @ { fetchurl, ... }:
rec {
  baseName = ''documentation-utils'';
  version = ''20180228-git'';

  description = ''A few simple tools to help you with documenting your library.'';

  deps = [ args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/documentation-utils/2018-02-28/documentation-utils-20180228-git.tgz'';
    sha256 = ''0jwbsm5qk2pg6fpzf9ny3gp780k5lqjgb5p6gv45s9h7x247pb2w'';
  };

  packageName = "documentation-utils";

  asdFilesToKeep = ["documentation-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM documentation-utils DESCRIPTION
    A few simple tools to help you with documenting your library. SHA256
    0jwbsm5qk2pg6fpzf9ny3gp780k5lqjgb5p6gv45s9h7x247pb2w URL
    http://beta.quicklisp.org/archive/documentation-utils/2018-02-28/documentation-utils-20180228-git.tgz
    MD5 b0c823120a376e0474433d151df52548 NAME documentation-utils FILENAME
    documentation-utils DEPS ((NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (trivial-indent) VERSION 20180228-git SIBLINGS NIL PARASITES
    NIL) */
