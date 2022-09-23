{ lib
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.9.3";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-C754uOezq5vsSWilG/N5XiZxABp4Cyt+vyriFSmI2jU=";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = "https://github.com/bulkan/robotframework-requests";
    license = licenses.mit;
  };

}
