{stdenv, fetchurl, aterm, sdf, strategoxt, stlport, pkgconfig}:

stdenv.mkDerivation {
  builder = ./builder.sh;
  name = "transformers-0.4";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/transformers-0.4.tar.bz2;
    md5 = "19f5b752aec5f4d09cf45cc199fd5bfb";
  };

  inherit stlport;
  buildInputs = [pkgconfig aterm sdf strategoxt stlport];
}
