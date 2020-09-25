{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.7.1";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "501a1c7415f839d6837eedd57f2b6ed20576aab318bf14e3878a77c9b106aa45";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with stdenv.lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = "https://github.com/bulkan/robotframework-requests";
    license = licenses.mit;
  };

}
