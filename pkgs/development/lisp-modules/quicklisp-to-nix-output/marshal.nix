args @ { fetchurl, ... }:
rec {
  baseName = ''marshal'';
  version = ''cl-20170124-git'';

  description = ''marshal: Simple (de)serialization of Lisp datastructures.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-marshal/2017-01-24/cl-marshal-20170124-git.tgz'';
    sha256 = ''0z43m3jspl4c4fcbbxm58hxd9k69308pyijgj7grmq6mirkq664d'';
  };

  packageName = "marshal";

  asdFilesToKeep = ["marshal.asd"];
  overrides = x: x;
}
/* (SYSTEM marshal DESCRIPTION
    marshal: Simple (de)serialization of Lisp datastructures. SHA256
    0z43m3jspl4c4fcbbxm58hxd9k69308pyijgj7grmq6mirkq664d URL
    http://beta.quicklisp.org/archive/cl-marshal/2017-01-24/cl-marshal-20170124-git.tgz
    MD5 ebde1b0f1c1abeb409380884cc665351 NAME marshal FILENAME marshal DEPS NIL
    DEPENDENCIES NIL VERSION cl-20170124-git SIBLINGS NIL PARASITES NIL) */
