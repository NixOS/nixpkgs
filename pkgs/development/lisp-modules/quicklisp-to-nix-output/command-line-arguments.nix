args @ { fetchurl, ... }:
rec {
  baseName = ''command-line-arguments'';
  version = ''20190710-git'';

  description = ''small library to deal with command-line arguments'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/command-line-arguments/2019-07-10/command-line-arguments-20190710-git.tgz'';
    sha256 = ''1221nraxk55mwgf6pilhzg5lh98jd0nxrdn2mj1zczj88im01733'';
  };

  packageName = "command-line-arguments";

  asdFilesToKeep = ["command-line-arguments.asd"];
  overrides = x: x;
}
/* (SYSTEM command-line-arguments DESCRIPTION
    small library to deal with command-line arguments SHA256
    1221nraxk55mwgf6pilhzg5lh98jd0nxrdn2mj1zczj88im01733 URL
    http://beta.quicklisp.org/archive/command-line-arguments/2019-07-10/command-line-arguments-20190710-git.tgz
    MD5 77b361a7f4b3b73a88c3a95c7bbffa98 NAME command-line-arguments FILENAME
    command-line-arguments DEPS NIL DEPENDENCIES NIL VERSION 20190710-git
    SIBLINGS NIL PARASITES NIL) */
