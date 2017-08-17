{ stdenv, lib, fetchurl, fetchgit, pkgconfig, lua5_1, libproxy, curl, glib, libgcrypt }:

let
    version = "0.9.2";
in
stdenv.mkDerivation rec {
  name = "libquvi-${version}";
  src = fetchgit {
      url = "https://github.com/mogaal/libquvi-scripts";
      rev = "c23ed0406f54831f9d6e242cc80948d173da0eea";
      sha256 = "0cki6cl5vaspcx51jx55fmy40rsrkdk308fifqix3rszv2x67bpx";
  };
  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lua5_1 libproxy curl libgcrypt glib];

  meta = {
    homepage = http://quvi.sourceforge.net/;
    description = "A selection of Lua scripts that libquvi calls upon to parse the properties for a media URL.";
    license = stdenv.lib.licenses.agpl3Plus;
    maintainers = [ stdenv.lib.maintainers.kiloreux ];
  };
}
