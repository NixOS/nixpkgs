{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "gettext-0.14";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/gettext-0.14.tar.gz;
    md5 = "e715be150bbe32439ae68fab32df0299";
  };
  configureFlags = "--disable-csharp";
}
