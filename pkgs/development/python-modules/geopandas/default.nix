{ lib, stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch, pythonOlder
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

  patches = [
    (fetchpatch {
      name = "skip-pandas-master-fillna-test.patch";
      url = "https://github.com/geopandas/geopandas/pull/1878.patch";
      sha256 = "1yw3i4dbhaq7f02n329b9y2cqxbwlz9db81mhgrfc7af3whwysdb";
    })
    (fetchpatch {
      name = "fix-proj4strings-test.patch";
      url = "https://github.com/geopandas/geopandas/pull/1958.patch";
      sha256 = "0kzmpq5ry87yvhqr6gnh9p2606b06d3ynzjvw0hpp9fncczpc2yn";
    })
  ];

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
