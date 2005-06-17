{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "gettext-0.14.5";
  src = fetchurl {
    url = ftp://ftp.gnu.org/pub/gnu/gettext/gettext-0.14.5.tar.gz;
    md5 = "e2f6581626a22a0de66dce1d81d00de3";
  };
  configureFlags = "--disable-csharp";
}
