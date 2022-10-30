{ lib
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.9.4";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4AlDuFJsOL7Vw8ZhyBPsnVohBpYb2R2gBocSwqDUnoI=";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = "https://github.com/bulkan/robotframework-requests";
    license = licenses.mit;
  };

}
