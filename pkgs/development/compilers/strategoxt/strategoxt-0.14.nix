{stdenv, fetchurl, aterm, sdf, pkgconfig}:

stdenv.mkDerivation {

  name = "strategoxt-0.14";
  builder = ./builder-0.14.sh;

  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.14/strategoxt-0.14.tar.gz;
    md5 = "143f01cc27231ccd5eddb695a7b79c69";
  };

  inherit aterm sdf;
  buildInputs = [pkgconfig aterm sdf];
}
