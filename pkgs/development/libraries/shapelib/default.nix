{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "shapelib";
  version = "1.6.0";

  src = fetchurl {
    url = "https://download.osgeo.org/shapelib/shapelib-${version}.tar.gz";
    sha256 = "sha256-GVKLJDdyQXBWNzIMNnlDAxrVCIZl0fsOHqpSpxJkpsQ=";
  };

  doCheck = true;
  preCheck = ''
    patchShebangs tests contrib/tests
  '';

  meta = with lib; {
    description = "C Library for reading, writing and updating ESRI Shapefiles";
    homepage = "http://shapelib.maptools.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; teams.geospatial.members ++ [ ehmry ];
  };
}
