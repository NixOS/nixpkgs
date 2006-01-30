{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "nasm-0.98.39";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/nasm-0.98.39.tar.bz2;
    md5 = "2032ad44c7359f7a9a166a40a633e772";
  };
}
