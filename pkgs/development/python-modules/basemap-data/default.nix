{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, basemap
, cython
, geos
, numpy
, matplotlib
, pyproj
, pyshp
, python
, setuptools
}:

buildPythonPackage rec {
  pname = "basemap-data";
  inherit (basemap) version src;

  sourceRoot = "source/packages/basemap_data";

  # no tests
  doCheck = false;

  pythonImportsCheck =  [ "mpl_toolkits.basemap_data" ];

  meta = with lib; {
    homepage = "https://matplotlib.org/basemap/";
    description = "Data assets for matplotlib basemap";
    license = with licenses; [ mit lgpl3Plus ];
    maintainers = with maintainers; [ ];
  };
}
