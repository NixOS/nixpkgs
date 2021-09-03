{ lib
, buildPythonPackage
, fetchFromGitHub
, geojson
, haversine
, pytz
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "geojson-client";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-geojson-client";
    rev = "v${version}";
    sha256 = "sha256-8eSLimCgFRn3cHTz5TE9fAUAbwFO72b23C0lg6fVOLQ=";
  };

  propagatedBuildInputs = [
    geojson
    haversine
    pytz
    requests
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "geojson_client" ];

  meta = with lib; {
    description = "Python module for convenient access to GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-geojson-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
