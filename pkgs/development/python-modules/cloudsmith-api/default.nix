{ lib
, buildPythonPackage
, fetchPypi
, certifi
, six
, python-dateutil
, urllib3
}:

buildPythonPackage rec {
  pname = "cloudsmith-api";
  version = "2.0.1";

  format = "wheel";

  src = fetchPypi {
    pname = "cloudsmith_api";
    inherit format version;
    sha256 = "sha256-wFSHlUdZTARsAV3igVXThrXoGsPUaZyzXBJCSJFZYYQ=";
  };

  propagatedBuildInputs = [
    certifi
    six
    python-dateutil
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
