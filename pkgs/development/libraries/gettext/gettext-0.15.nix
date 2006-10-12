{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "gettext-0.15";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gettext-0.15.tar.gz;
    md5 = "16bc6e4d37ac3d07495f737a2349a22b";
  };
  configureFlags = "--disable-csharp";
}
