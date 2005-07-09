{stdenv, fetchurl, aterm, sdf, pkgconfig}:

stdenv.mkDerivation {

  name = "strategoxt-0.15";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.15/strategoxt-0.15.tar.gz;
    md5 = "2f6dbbf09abe3b2fb14c2a5126e5c970";
  };

  inherit aterm sdf;
  buildInputs = [pkgconfig aterm sdf];
}
