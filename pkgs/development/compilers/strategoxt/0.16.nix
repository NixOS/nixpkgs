{stdenv, fetchurl, aterm, sdf, pkgconfig}:

stdenv.mkDerivation {

  name = "strategoxt-0.16";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/stratego/strategoxt-0.16/strategoxt-0.16.tar.gz;
    md5 = "8b8eabbd785faa84ec20134b63d4829e";
  };

  inherit aterm sdf;
  buildInputs = [pkgconfig aterm sdf];
}
