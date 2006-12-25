{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "gettext-0.16.1";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/gettext/gettext-0.16.1.tar.gz;
    md5 = "3d9ad24301c6d6b17ec30704a13fe127";
  };
  configureFlags = "--disable-csharp";
}
