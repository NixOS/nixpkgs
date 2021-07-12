{ lib, stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, pandas, shapely, fiona, pyproj
, pytestCheckHook, Rtree }:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.9.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "v${version}";
    sha256 = "sha256-58X562OkRzZ4UTNMTwXW4U5czoa5tbSMBCcE90DqbaE=";
  };

  propagatedBuildInputs = [
    pandas
    shapely
    fiona
    pyproj
  ];

  doCheck = !stdenv.isDarwin;
  checkInputs = [ pytestCheckHook Rtree ];
  disabledTests = [
    # requires network access
    "test_read_file_remote_geojson_url"
    "test_read_file_remote_zipfile_url"
  ];
  pytestFlagsArray = [ "geopandas" ];

  meta = with lib; {
    description = "Python geospatial data analysis framework";
    homepage = "https://geopandas.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
