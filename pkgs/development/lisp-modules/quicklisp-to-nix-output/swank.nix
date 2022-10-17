/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "swank";
  version = "slime-v2.26.1";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/slime/2020-12-20/slime-v2.26.1.tgz";
    sha256 = "12q3la9lwzs01x0ii5vss0i8i78lgyjrn3adr3rs027f4b7386ny";
  };

  packageName = "swank";

  asdFilesToKeep = ["swank.asd"];
  overrides = x: x;
}
/* (SYSTEM swank DESCRIPTION System lacks description SHA256
    12q3la9lwzs01x0ii5vss0i8i78lgyjrn3adr3rs027f4b7386ny URL
    http://beta.quicklisp.org/archive/slime/2020-12-20/slime-v2.26.1.tgz MD5
    bd91e1fe29a4f7ebf53a0bfecc9e1e36 NAME swank FILENAME swank DEPS NIL
    DEPENDENCIES NIL VERSION slime-v2.26.1 SIBLINGS NIL PARASITES NIL) */
