{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.11.2";
  name = "mdds-${version}";

  src = fetchurl {
    url = "http://kohei.us/files/mdds/src/mdds_${version}.tar.bz2";
    sha256 = "1ax50ahgl549gw76p8kbd5cb0kkihrn59638mppq4raxng40s2nd";
  };

  postInstall = ''
   mkdir -p "$out/lib/pkgconfig"
   cp "$out/share/pkgconfig/"* "$out/lib/pkgconfig"
  '';

  meta = {
    inherit version;
    homepage = https://code.google.com/p/multidimalgorithm/;
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = stdenv.lib.platforms.all;
  };
}
