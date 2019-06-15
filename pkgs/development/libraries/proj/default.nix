{ stdenv, fetchurl, sqlite, pkg-config  }:

stdenv.mkDerivation {
  name = "proj-6.1.0";

  src = fetchurl {
    url = https://download.osgeo.org/proj/proj-6.1.0.tar.gz;
    sha256 = "0240g1jdqj6qj40sjrz8bwi0nhzb8irvv71llhyz1lhr8g2naqb7";
  };

  doCheck = stdenv.is64bit;

  buildInputs = [ sqlite ];

  nativeBuildInputs = [ pkg-config ];

  meta = with stdenv.lib; {
    description = "Cartographic Projections Library";
    homepage = https://proj4.org;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ vbgl ];
  };
}
