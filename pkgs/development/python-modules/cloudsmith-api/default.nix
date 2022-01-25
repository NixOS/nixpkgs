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
  version = "1.8.2";

  format = "wheel";

  src = fetchPypi {
    pname = "cloudsmith_api";
    inherit format version;
    sha256 = "f00410210f0efa1af7a2d344deafc12b946e3efc7d5c8374b27dc67ed8580183";
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
