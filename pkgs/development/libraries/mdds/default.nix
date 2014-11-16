{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.11.1";
  name = "mdds-${version}";

  src = fetchurl {
    url = "http://kohei.us/files/mdds/src/mdds_${version}.tar.bz2";
    sha256 = "1xr74ss8vr67nmwxls4a54hgljwrc8fs485ablh0bxykf6dyr0j1";
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
