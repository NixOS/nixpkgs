{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da7bf998f9cbf8261199db7c96b95be1bf29d1db7f59dfbc77c435761698dc75";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with stdenv.lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = "https://github.com/bulkan/robotframework-requests";
    license = licenses.mit;
  };

}
