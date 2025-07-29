{
  buildOctavePackage,
  lib,
  fetchurl,
  io, # >= 2.2.7
  geometry, # >= 4.0.0
  gdal,
}:

buildOctavePackage rec {
  pname = "mapping";
  version = "1.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-IYiyRjnHCHhAFy5gR/dcuKWY11gSCubggQzmMAqGmhs=";
  };

  propagatedBuildInputs = [
    gdal
  ];

  requiredOctavePackages = [
    io
    geometry
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/mapping/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Simple mapping and GIS .shp .dxf and raster file functions";
  };
}
