{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fiona
, packaging
, pandas
, pyproj
, pytestCheckHook
, pythonOlder
, Rtree
, shapely
}:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-+9hPRPR9AJZqITc3CINEKWyFb+GQiRwbsdvlXxQBRu8=";
  };

  propagatedBuildInputs = [
    fiona
    packaging
    pandas
    pyproj
    shapely
  ];

  checkInputs = [
    pytestCheckHook
    Rtree
  ];

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Requires network access
    "test_read_file_remote_geojson_url"
    "test_read_file_remote_zipfile_url"
  ];

  pytestFlagsArray = [
    "geopandas"
  ];

  pythonImportsCheck = [
    "geopandas"
  ];

  meta = with lib; {
    description = "Python geospatial data analysis framework";
    homepage = "https://geopandas.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
