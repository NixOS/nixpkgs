{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "shapelib";
  version = "1.5.0";

  src = fetchurl {
    url = "https://download.osgeo.org/shapelib/shapelib-${version}.tar.gz";
    sha256 = "1qfsgb8b3yiqwvr6h9m81g6k9fjhfys70c22p7kzkbick20a9h0z";
  };

  meta = with lib; {
    description = "C Library for reading, writing and updating ESRI Shapefiles";
    homepage = "http://shapelib.maptools.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
  };
}
