{stdenv, fetchurl, regexp}:

stdenv.mkDerivation {
  name = "jakarta-bcel-5.1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nixos.org/tarballs/bcel-5.1.tar.gz;
    md5 = "318f22e4f5f59b68cd004db83a7d65dc";
  };

  inherit regexp;
  buildInputs = [stdenv];
}
