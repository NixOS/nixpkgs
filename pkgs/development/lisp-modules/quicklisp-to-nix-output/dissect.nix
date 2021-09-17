/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "dissect";
  version = "20200427-git";

  description = "A lib for introspecting the call stack and active restarts.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/dissect/2020-04-27/dissect-20200427-git.tgz";
    sha256 = "1d7sri20jma9r105lxv0sx2q60kb8zp7bf023kain3rnyqr74v8a";
  };

  packageName = "dissect";

  asdFilesToKeep = ["dissect.asd"];
  overrides = x: x;
}
/* (SYSTEM dissect DESCRIPTION
    A lib for introspecting the call stack and active restarts. SHA256
    1d7sri20jma9r105lxv0sx2q60kb8zp7bf023kain3rnyqr74v8a URL
    http://beta.quicklisp.org/archive/dissect/2020-04-27/dissect-20200427-git.tgz
    MD5 2cce2469353cac86ee3c0358b9b99f3d NAME dissect FILENAME dissect DEPS NIL
    DEPENDENCIES NIL VERSION 20200427-git SIBLINGS NIL PARASITES NIL) */
