{stdenv, fetchurl, aterm, sdf}:

stdenv.mkDerivation {

  name = "strategoxt-0.13";

  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.13/strategoxt-0.13.tar.gz;
    md5 = "783bea5d5ebc0604e7ecf5bfb8f7f7b1";
  };

  inherit aterm;
  inherit (sdf) sglr pgen ptsupport asflibrary;

  buildInputs = [aterm sdf.pgen];
}
