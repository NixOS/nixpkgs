{ lib, stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, pandas, shapely, fiona, pyproj
, pytestCheckHook, Rtree }:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.10.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "v${version}";
    sha256 = "14azl3gppqn90k8h4hpjilsivj92k6p1jh7mdr6p4grbww1b7sdq";
  };

  propagatedBuildInputs = [
    pandas
    shapely
    fiona
    pyproj
  ];

  doCheck = !stdenv.isDarwin;
  preCheck = ''
    # Wants to write test files into $HOME.
    export HOME="$TMPDIR"
  '';
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
