{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.6.2";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "30669de238f7efd171ccab1c19c7f30ed6b77f43db534c173c1fa1568194d4cb";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with stdenv.lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = https://github.com/bulkan/robotframework-requests;
    license = licenses.mit;
  };

}
