{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pandas,
  pyarrow,
  pyproj,
  shapely,
  geopandas,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "geoparquet";
  version = "0.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darcy-r";
    repo = "geoparquet-python";
    rev = "b09b12dd0ebc34d73f082c3d97ccb69a889167e3";
    hash = "sha256-WGZfDQh7Abh83n8jsCGr41IlKKq7QVDlauuWi20llh8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pandas
    pyarrow
    pyproj
    shapely
    geopandas
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportCheck = "geoparquet";

  doCheck = false; # no tests

  meta = {
    description = "API between Parquet files and GeoDataFrames for fast input/output of GIS data";
    homepage = "https://github.com/darcy-r/geoparquet-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
