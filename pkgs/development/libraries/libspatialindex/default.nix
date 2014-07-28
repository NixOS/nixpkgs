{ stdenv, fetchurl }:

let version = "1.8.1"; in

stdenv.mkDerivation rec {
  name = "libspatialindex-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/libspatialindex/spatialindex-src-${version}.tar.gz";
    sha256 = "1ay1kxn4baccd0cqx466v7fn8c8gcfbhlnd5mbdnd7s4aw0ix88j";
  };

  enableParallelBuilding = true;

  meta = {
    description = "Extensible spatial index library in C++";
    homepage = http://libspatialindex.github.io/;
    license = stdenv.lib.licenses.mit;
  };
}
