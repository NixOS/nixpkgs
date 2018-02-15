args @ { fetchurl, ... }:
rec {
  baseName = ''form-fiddle'';
  version = ''20180131-git'';

  description = ''A collection of utilities to destructure lambda forms.'';

  deps = [ args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/form-fiddle/2018-01-31/form-fiddle-20180131-git.tgz'';
    sha256 = ''1i7rzn4ilr46wpkd2i10q875bxy8b54v7rvqzcq752hilx15hiff'';
  };

  packageName = "form-fiddle";

  asdFilesToKeep = ["form-fiddle.asd"];
  overrides = x: x;
}
/* (SYSTEM form-fiddle DESCRIPTION
    A collection of utilities to destructure lambda forms. SHA256
    1i7rzn4ilr46wpkd2i10q875bxy8b54v7rvqzcq752hilx15hiff URL
    http://beta.quicklisp.org/archive/form-fiddle/2018-01-31/form-fiddle-20180131-git.tgz
    MD5 a0cc2ea1af29889e4991f7fefac366dd NAME form-fiddle FILENAME form-fiddle
    DEPS
    ((NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (documentation-utils trivial-indent) VERSION 20180131-git
    SIBLINGS NIL PARASITES NIL) */
