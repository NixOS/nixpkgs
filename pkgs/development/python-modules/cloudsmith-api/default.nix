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
  version = "2.0.12";
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "cloudsmith_api";
    inherit format version;
    hash = "sha256-a33t963Q5+gnZI9pha4viuyWz3xLHUdcGE4ccw/w0s8=";
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
    maintainers = with maintainers; [ ];
  };
}
