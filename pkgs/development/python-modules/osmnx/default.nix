{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  folium,
  gdal,
  geopandas,
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
  uv-build,
}:

buildPythonPackage rec {
  pname = "osmnx";
  version = "2.0.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "gboeing";
    repo = "osmnx";
    tag = "v${version}";
    hash = "sha256-y2gKToDzG1IIcLN+hK/WeS+/z6MNabiIr+8Em1Ct72Q=";
  };

  build-system = [ uv-build ];

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
    teams = [ lib.teams.geospatial ];
  };
}
