{stdenv, fetchurl, aterm, sdf}:

stdenv.mkDerivation {

  name = "strategoxt-0.12";

  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.12.tar.gz;
    md5 = "bc2b14d9b53a07fc0047c16f2c6edf0c";
  };

  inherit aterm;
  inherit (sdf) sglr pgen ptsupport asflibrary;

  buildInputs = [aterm sdf.pgen];
}
