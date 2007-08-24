{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "gettext-0.14.6";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/gettext/gettext-0.14.6.tar.gz;
    md5 = "c26fc7f0a493c5c7c39bbc4e7ed42790";
  };
  configureFlags = "--disable-csharp";
}
