{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.2.1";
  name = "mdds-${version}";

  src = fetchurl {
    url = "http://kohei.us/files/mdds/src/mdds-${version}.tar.bz2";
    sha256 = "0yzwdl8mf8xdj8rif1qq0qnlq7vlk5q86r3hs2x49m5rqzgljbqy";
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
