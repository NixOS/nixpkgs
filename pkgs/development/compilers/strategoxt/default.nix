{stdenv, fetchurl, aterm, sdf}:

stdenv.mkDerivation {
  name = "strategoxt-0.9.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.9.4.tar.gz;
    md5 = "b61aee784cebac6cce0d96383bdb1b37";
  };
  inherit aterm sdf;
}
