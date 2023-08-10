{ lib
, stdenv
, bison
, flex
, fetchurl
}:

let
  version = "3.3.0";
  pname = "libcanlock";

in stdenv.mkDerivation {
  inherit version pname;

  src = fetchurl {
    url =
      "https://micha.freeshell.org/libcanlock/src/libcanlock-${version}.tar.bz2";
    hash = "sha256-pwn1nWYRAxwpO0g8+gvmw31saCIMyUruROSp6r92mI0=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [ ];

  meta = {
    description =
      " A standalone RFC 8315 Netnews Cancel-Lock implementation for Unix";
    homepage = "https://micha.freeshell.org/libcanlock/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ne9z ];
  };
}
