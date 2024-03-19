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
, rtree
, shapely
}:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.14.3";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-qAINoqnCVfpg2mQhnu0qT/5EjUB+9a3//H8vJJnyj6A=";
  };

  propagatedBuildInputs = [
    fiona
    packaging
    pandas
    pyproj
    shapely
  ];

  nativeCheckInputs = [
    pytestCheckHook
    rtree
  ];

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Requires network access
    "test_read_file_url"
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
    changelog = "https://github.com/geopandas/geopandas/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
