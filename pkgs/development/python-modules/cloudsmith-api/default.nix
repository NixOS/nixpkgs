{ lib
, buildPythonPackage
, certifi
, fetchPypi
, python-dateutil
, pythonOlder
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "cloudsmith-api";
  version = "2.0.1";
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "cloudsmith_api";
    inherit format version;
    hash = "sha256-wFSHlUdZTARsAV3igVXThrXoGsPUaZyzXBJCSJFZYYQ=";
  };

  propagatedBuildInputs = [
    certifi
    python-dateutil
    six
    urllib3
  ];

  # Wheels have no tests
  doCheck = false;

  pythonImportsCheck = [
    "cloudsmith_api"
  ];

  meta = with lib; {
    description = "Cloudsmith API Client";
    homepage = "https://github.com/cloudsmith-io/cloudsmith-api";
    license = licenses.asl20;
    maintainers = with maintainers; [ jtojnar ];
  };
}
