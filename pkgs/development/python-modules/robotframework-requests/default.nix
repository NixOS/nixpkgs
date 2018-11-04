{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.5.0";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c253b8061c8a91251abf3ebadc33152b8621671621405dd343efd17bdc9e620";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with stdenv.lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = https://github.com/bulkan/robotframework-requests;
    license = licenses.mit;
  };

}
