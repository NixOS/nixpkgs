{ lib
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.7.2";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "662e0ce5036a55bcb4cb46ff9741f40c78c670f4fb64cd37714cf83d5fd31774";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = "https://github.com/bulkan/robotframework-requests";
    license = licenses.mit;
  };

}
