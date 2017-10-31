args @ { fetchurl, ... }:
rec {
  baseName = ''form-fiddle'';
  version = ''20170630-git'';

  description = ''A collection of utilities to destructure lambda forms.'';

  deps = [ args."documentation-utils" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/form-fiddle/2017-06-30/form-fiddle-20170630-git.tgz'';
    sha256 = ''0w4isi9y2h6vswq418hj50223aac89iadl71y86wxdlznm3kdvjf'';
  };

  packageName = "form-fiddle";

  asdFilesToKeep = ["form-fiddle.asd"];
  overrides = x: x;
}
/* (SYSTEM form-fiddle DESCRIPTION
    A collection of utilities to destructure lambda forms. SHA256
    0w4isi9y2h6vswq418hj50223aac89iadl71y86wxdlznm3kdvjf URL
    http://beta.quicklisp.org/archive/form-fiddle/2017-06-30/form-fiddle-20170630-git.tgz
    MD5 9c8eb18dfedebcf43718cc259c910aa1 NAME form-fiddle FILENAME form-fiddle
    DEPS ((NAME documentation-utils FILENAME documentation-utils)) DEPENDENCIES
    (documentation-utils) VERSION 20170630-git SIBLINGS NIL PARASITES NIL) */
