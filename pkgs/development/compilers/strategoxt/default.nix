{stdenv, fetchurl, aterm, sdf}:

derivation {
  name = "strategoxt-0.9.4";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.9.4.tar.gz;
    md5 = "b61aee784cebac6cce0d96383bdb1b37";
  };
  inherit stdenv aterm sdf;
}
