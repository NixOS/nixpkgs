{stdenv, fetchurl, aterm, sdf}: derivation {
  name = "strategoxt-0.9.3";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.9.3.tar.gz;
    md5 = "3425e7ae896426481bd258817737e3d6"
  };
  stdenv = stdenv;
  aterm = aterm;
  sdf = sdf;
  tarfile = "true";
  dir = "strategoxt";
}
