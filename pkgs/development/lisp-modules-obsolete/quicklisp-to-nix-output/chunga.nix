/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "chunga";
  version = "20200427-git";

  description = "System lacks description";

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/chunga/2020-04-27/chunga-20200427-git.tgz";
    sha256 = "0p6dlnan6raincd682brcjbklyvmkfkhz0yzp2bkfw67s9615bkk";
  };

  packageName = "chunga";

  asdFilesToKeep = ["chunga.asd"];
  overrides = x: x;
}
/* (SYSTEM chunga DESCRIPTION System lacks description SHA256
    0p6dlnan6raincd682brcjbklyvmkfkhz0yzp2bkfw67s9615bkk URL
    http://beta.quicklisp.org/archive/chunga/2020-04-27/chunga-20200427-git.tgz
    MD5 ec31aa63a1b594a197ad45e5e65c4cc4 NAME chunga FILENAME chunga DEPS
    ((NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES
    (trivial-gray-streams) VERSION 20200427-git SIBLINGS NIL PARASITES NIL) */
