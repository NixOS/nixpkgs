{stdenv, fetchurl, aterm, sdf}:

stdenv.mkDerivation {
  name = "strategoxt-0.11";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.11.tar.gz;
    md5 = "bf6c38179f6883b01fa3e548c4f45f1c";
  };
  inherit aterm sdf;
  buildInputs = [aterm sdf];
}
