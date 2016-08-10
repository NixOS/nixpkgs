{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.12.1";
  name = "mdds-${version}";

  src = fetchurl {
    url = "http://kohei.us/files/mdds/src/mdds_${version}.tar.bz2";
    sha256 = "0gg8mb9kxh3wggh7njj1gf90xy27p0yq2cw88wqar9hhg2fmwmi3";
  };

  postInstall = ''
   mkdir -p "$out/lib/pkgconfig"
   cp "$out/share/pkgconfig/"* "$out/lib/pkgconfig"
  '';

  meta = {
    inherit version;
    homepage = "https://gitlab.com/mdds/mdds";
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = stdenv.lib.platforms.all;
  };
}
