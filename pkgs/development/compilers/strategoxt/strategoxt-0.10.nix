{stdenv, fetchurl, aterm, sdf}:

stdenv.mkDerivation {

  name = "strategoxt-0.10";

  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.10.tar.gz;
    md5 = "526a28e84248b649bb098b22d227cd26";
  };

  inherit aterm;
  inherit (sdf) sglr pgen ptsupport asflibrary;

  buildInputs = [aterm sdf.pgen];
}
