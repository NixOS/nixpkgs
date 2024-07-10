{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,
  setuptools,

  fiona,
  packaging,
  pandas,
  pyproj,
  rtree,
  shapely,
}:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.14.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-FBhPcae8bnNnsfr14I1p22VhoOf9USF9DAcrAqx+zso=";
  };

  patches = [
    # GDAL 3.9 compat for boolean array in shp
    (fetchpatch {
      url = "https://github.com/geopandas/geopandas/commit/f1be60532bed31cb410ce4db2da6b733bc8713c9.patch";
      sha256 = "sha256-DZhC7sSOki0XTcojSRvVVSlsnYnxCw/Ee7vHBmDCsbA=";
    })

    # GDAL 3.9 compat for boolean array in shp for fiona
    (fetchpatch {
      url = "https://github.com/geopandas/geopandas/commit/1e08422d8aee4877752047a8a08f41e3a67188f2.patch";
      sha256 = "sha256-SpNqe7jL1rA79YhhSUfEzt30plt56Tux5v1h7IHp31I=";
    })
  ];

  build-system = [ setuptools ];

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

  pytestFlagsArray = [ "geopandas" ];

  pythonImportsCheck = [ "geopandas" ];

  meta = with lib; {
    description = "Python geospatial data analysis framework";
    homepage = "https://geopandas.org";
    changelog = "https://github.com/geopandas/geopandas/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
