{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "gettext-0.14.5";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gettext-0.14.5.tar.gz;
    md5 = "e2f6581626a22a0de66dce1d81d00de3";
  };
  configureFlags = "--disable-csharp";
}
