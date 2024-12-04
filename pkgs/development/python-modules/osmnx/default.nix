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
  version = "1.9.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "gboeing";
    repo = "osmnx";
    rev = "refs/tags/v${version}";
    hash = "sha256-Tn800wFoPi5VkZmu9wUVM+EmCj/xxU2EJ6iwnA1VKXo=";
  };

  build-system = [ hatchling ];

  dependencies = [
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

  meta = {
    description = "Package to easily download, construct, project, visualize, and analyze complex street networks from OpenStreetMap with NetworkX";
    homepage = "https://github.com/gboeing/osmnx";
    changelog = "https://github.com/gboeing/osmnx/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
}
