{stdenv, fetchurl, dylan, boehmgc, perl, flex, yacc, readline}:

stdenv.mkDerivation {
  name = "gwydion-dylan-2.4.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gwydion-dylan-2.4.0.tar.gz;
    md5 = "7ed180bf4ef11e8e8da3bd78b45477a8";
  };

  inherit boehmgc dylan perl;
  buildInputs = [boehmgc dylan perl flex yacc readline];
}
