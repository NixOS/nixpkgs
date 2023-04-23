{ lib
, buildPythonPackage
, fetchFromGitHub
, folium
, gdal
, geopandas
, matplotlib
, networkx
, numpy
, pandas
, pythonOlder
, rasterio
, requests
, rtree
, scikit-learn
, scipy
, shapely
}:

buildPythonPackage rec {
  pname = "osmnx";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gboeing";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-17duWrg48Qb4ojYYFX4HBpPLeVgHn1WV84KVATvBnzY=";
  };

  propagatedBuildInputs = [
    geopandas
    matplotlib
    networkx
    numpy
    pandas
    requests
    rtree
    shapely
    folium
    scikit-learn
    scipy
    gdal
    rasterio
  ];

  # Tests require network
  doCheck = false;

  pythonImportsCheck = [
    "osmnx"
  ];

  meta = with lib; {
    description = "A package to easily download, construct, project, visualize, and analyze complex street networks from OpenStreetMap with NetworkX.";
    homepage = "https://github.com/gboeing/osmnx";
    changelog = "https://github.com/gboeing/osmnx/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

