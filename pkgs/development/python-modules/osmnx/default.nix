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
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gboeing";
    repo = "osmnx";
    tag = "v${version}";
    hash = "sha256-3uLgc6zptmXlPg93qtsWbqNxXiBD/SEnXBL/IM/1m2c=";
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
