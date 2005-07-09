{stdenv, fetchurl, aterm, sdf, pkgconfig}:

stdenv.mkDerivation {

  name = "strategoxt-0.15";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.15/strategoxt-0.15.tar.gz;
    md5 = "143f01cc27231ccd5eddb695a7b79c69";
  };

  inherit aterm sdf;
  buildInputs = [pkgconfig aterm sdf];
}
