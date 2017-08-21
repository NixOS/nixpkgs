{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.2.2";
  name = "mdds-${version}";

  src = fetchurl {
    url = "http://kohei.us/files/mdds/src/mdds-${version}.tar.bz2";
    sha256 = "17fcjhsq3bzqm7ba9sgp6my3y4226jnwai6q5jq3810i745p67hl";
  };

  postInstall = ''
   mkdir -p "$out/lib/pkgconfig"
   cp "$out/share/pkgconfig/"* "$out/lib/pkgconfig"
  '';

  meta = {
    inherit version;
    homepage = https://gitlab.com/mdds/mdds;
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = stdenv.lib.platforms.all;
  };
}
