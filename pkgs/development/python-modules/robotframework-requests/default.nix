{ lib
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.9.1";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22ea105846b28ddfc49713c59a363ad636ece5e308476dea59e73e3c9b544755";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = "https://github.com/bulkan/robotframework-requests";
    license = licenses.mit;
  };

}
