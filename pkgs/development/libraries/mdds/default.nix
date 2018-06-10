{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.3.1";
  name = "mdds-${version}";

  src = fetchurl {
    url = "http://kohei.us/files/mdds/src/mdds-${version}.tar.bz2";
    sha256 = "18g511z1lgfxrga2ld9yr95phmyfbd3ymbv4q5g5lyjn4ljcvf6w";
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
