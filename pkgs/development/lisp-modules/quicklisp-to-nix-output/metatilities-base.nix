args @ { fetchurl, ... }:
rec {
  baseName = ''metatilities-base'';
  version = ''20170403-git'';

  description = ''These are metabang.com's Common Lisp basic utilities.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/metatilities-base/2017-04-03/metatilities-base-20170403-git.tgz'';
    sha256 = ''14c1kzpg6ydnqca95rprzmhr09kk1jp2m8hpyn5vj2v68cvqm7br'';
  };

  packageName = "metatilities-base";

  asdFilesToKeep = ["metatilities-base.asd"];
  overrides = x: x;
}
/* (SYSTEM metatilities-base DESCRIPTION
    These are metabang.com's Common Lisp basic utilities. SHA256
    14c1kzpg6ydnqca95rprzmhr09kk1jp2m8hpyn5vj2v68cvqm7br URL
    http://beta.quicklisp.org/archive/metatilities-base/2017-04-03/metatilities-base-20170403-git.tgz
    MD5 8a3f429862a368e63b8fde731e9ab28a NAME metatilities-base FILENAME
    metatilities-base DEPS NIL DEPENDENCIES NIL VERSION 20170403-git SIBLINGS
    (metatilities-base-test) PARASITES NIL) */
