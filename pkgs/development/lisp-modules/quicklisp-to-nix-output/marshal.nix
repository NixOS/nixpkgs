args @ { fetchurl, ... }:
rec {
  baseName = ''marshal'';
  version = ''cl-20170830-git'';

  description = ''marshal: Simple (de)serialization of Lisp datastructures.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-marshal/2017-08-30/cl-marshal-20170830-git.tgz'';
    sha256 = ''1yirhxyizfxsvsrmbh2dipzzlq09afahzmi2zlsbbv6cvijxnisp'';
  };

  packageName = "marshal";

  asdFilesToKeep = ["marshal.asd"];
  overrides = x: x;
}
/* (SYSTEM marshal DESCRIPTION
    marshal: Simple (de)serialization of Lisp datastructures. SHA256
    1yirhxyizfxsvsrmbh2dipzzlq09afahzmi2zlsbbv6cvijxnisp URL
    http://beta.quicklisp.org/archive/cl-marshal/2017-08-30/cl-marshal-20170830-git.tgz
    MD5 54bce031cdb215cd7624fdf3265b9bec NAME marshal FILENAME marshal DEPS NIL
    DEPENDENCIES NIL VERSION cl-20170830-git SIBLINGS (marshal-tests) PARASITES
    NIL) */
