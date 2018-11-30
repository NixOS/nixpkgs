{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.4.6";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0416rxg7g0pfg77akljnkass0xz0id26v4saag2q2h1fgwrm7n4q";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with stdenv.lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = https://github.com/bulkan/robotframework-requests;
    license = licenses.mit;
  };

}
