{ lib
, buildPythonPackage
, fetchFromGitHub
, geojson
, haversine
, pytz
, requests
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "geojson-client";
  version = "0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-geojson-client";
    rev = "v${version}";
    sha256 = "sha256-7EhdIfVM6d5fp6k+RdX6z33O5sZGeF/ThNkSXL8EjE8=";
  };

  propagatedBuildInputs = [
    geojson
    haversine
    pytz
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "geojson_client"
  ];

  meta = with lib; {
    description = "Python module for convenient access to GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-geojson-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
