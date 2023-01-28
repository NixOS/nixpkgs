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
, Rtree
, scikit-learn
, scipy
, shapely
}:

buildPythonPackage rec {
  pname = "osmnx";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gboeing";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+dUv1QrUmCIOCyUyjYX1kJtZrPuSp3t9xz/sRV7ppgA=";
  };

  propagatedBuildInputs = [
    geopandas
    matplotlib
    networkx
    numpy
    pandas
    requests
    Rtree
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

