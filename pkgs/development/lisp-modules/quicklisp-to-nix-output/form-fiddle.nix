args @ { fetchurl, ... }:
rec {
  baseName = ''form-fiddle'';
  version = ''20180831-git'';

  description = ''A collection of utilities to destructure lambda forms.'';

  deps = [ args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/form-fiddle/2018-08-31/form-fiddle-20180831-git.tgz'';
    sha256 = ''013n10rzqbfvdlz37pdmj4y7qv3fzv7q2hxv8aw7kcirg5gl7mkj'';
  };

  packageName = "form-fiddle";

  asdFilesToKeep = ["form-fiddle.asd"];
  overrides = x: x;
}
/* (SYSTEM form-fiddle DESCRIPTION
    A collection of utilities to destructure lambda forms. SHA256
    013n10rzqbfvdlz37pdmj4y7qv3fzv7q2hxv8aw7kcirg5gl7mkj URL
    http://beta.quicklisp.org/archive/form-fiddle/2018-08-31/form-fiddle-20180831-git.tgz
    MD5 1e9ae81423ed3c5f2e07c26f93b45956 NAME form-fiddle FILENAME form-fiddle
    DEPS
    ((NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (documentation-utils trivial-indent) VERSION 20180831-git
    SIBLINGS NIL PARASITES NIL) */
