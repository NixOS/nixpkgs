{ stdenv, fetchurl, boost }:

stdenv.mkDerivation rec {
  version = "1.4.1";
  name = "mdds-${version}";

  src = fetchurl {
    url = "https://kohei.us/files/mdds/src/mdds-${version}.tar.bz2";
    sha256 = "1hs4lhmmr44ynljn7bjsyvnjbbfrz7dda18lan4dq1jzgz1r1ils";
  };

  postInstall = ''
   mkdir -p "$out/lib/pkgconfig"
   cp "$out/share/pkgconfig/"* "$out/lib/pkgconfig"
  '';

  checkInputs = [ boost ];

  meta = {
    inherit version;
    homepage = https://gitlab.com/mdds/mdds;
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = stdenv.lib.platforms.all;
  };
}
