{stdenv, fetchurl, aterm, sdf, pkgconfig}:

stdenv.mkDerivation {

  name = "strategoxt-0.16M2pre13214";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/stratego/strategoxt-0.16M2pre13214/strategoxt-0.16M2pre13214.tar.gz;
    md5 = "a28b34f3d527e026aab9225a9e4db03a";
  };

  inherit aterm sdf;
  buildInputs = [pkgconfig aterm sdf];
}
