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
<<<<<<< HEAD
  version = "0.13.2";
=======
  version = "0.12.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-8H0IO+Oabl1ZOHHvMFHnPEyW0xH/G4wuUtkZrsP6K3k=";
=======
    hash = "sha256-ntOZ2WCoMz5ZpqPeupqPC3cN8mbQmEAvJGaFblu0ibY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    "test_read_file_url"
=======
    "test_read_file_remote_geojson_url"
    "test_read_file_remote_zipfile_url"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = teams.geospatial.members;
=======
    maintainers = with maintainers; [ knedlsepp ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
