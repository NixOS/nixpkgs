{stdenv, fetchurl, aterm, sdf}: derivation {
  name = "strategoxt-0.9.5";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.9.5.tar.gz;
    md5 = "c3caea5c05f8d8439450866b6d5664df";
  };
  inherit stdenv aterm sdf;
  tarfile = "true";
  dir = "strategoxt";
}
