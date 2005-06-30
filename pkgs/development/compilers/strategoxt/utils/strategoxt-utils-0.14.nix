{stdenv, fetchurl, aterm, sdf, strategoxt, pkgconfig}:

stdenv.mkDerivation {
  name = "strategoxt-utils-0.14";
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.14/strategoxt-utils-0.14.tar.gz;
    md5 = "d9aab7fbda5b93fb7c49434131393324";
  };

  inherit aterm sdf;
  buildInputs = [pkgconfig aterm sdf strategoxt];
}
