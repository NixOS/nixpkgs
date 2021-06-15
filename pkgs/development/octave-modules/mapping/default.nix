{ buildOctavePackage
, lib
, fetchurl
, io # >= 2.2.7
, geometry # >= 4.0.0
}:

buildOctavePackage rec {
  pname = "mapping";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0wj0q1rkrqs4qgpjh4vn9kcpdh94pzr6v4jc1vcrjwkp87yjv8c0";
  };

  requiredOctavePackages = [
    io
    geometry
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/mapping/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Simple mapping and GIS .shp .dxf and raster file functions";
  };
}
