{ lib
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.8.1";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b26f4ae617ff8c4b522fba422b7c8f83545a98aec3e2deb7f1aa53dcd68defe2";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = "https://github.com/bulkan/robotframework-requests";
    license = licenses.mit;
  };

}
