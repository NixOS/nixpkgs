{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.12.0";
  name = "mdds-${version}";

  src = fetchurl {
    url = "http://kohei.us/files/mdds/src/mdds_${version}.tar.bz2";
    sha256 = "10ar7r0gkdl2r7916jlkl5c38cynrh7x9s90a5i8d242r8ixw8ia";
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
