{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  folium,
  gdal,
  geopandas,
  hatchling,
  matplotlib,
  networkx,
  numpy,
  pandas,
  pythonOlder,
  rasterio,
  requests,
  rtree,
  scikit-learn,
  scipy,
  shapely,
}:

buildPythonPackage rec {
  pname = "osmnx";
  version = "1.9.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gboeing";
    repo = "osmnx";
    rev = "refs/tags/v${version}";
    hash = "sha256-od/0IuiK2CvrD0lfcTzkImK/5hcm6m61ULYzEtv/YeA=";
  };

  nativeBuildInputs = [ hatchling ];

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

  pythonImportsCheck = [ "osmnx" ];

  meta = with lib; {
    description = "Package to easily download, construct, project, visualize, and analyze complex street networks from OpenStreetMap with NetworkX";
    homepage = "https://github.com/gboeing/osmnx";
    changelog = "https://github.com/gboeing/osmnx/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
