{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.6.3";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f29844eee373775fd590b80f80a7d5a4325094a4f0a3c48e972d24712dbd2ce4";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with stdenv.lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = https://github.com/bulkan/robotframework-requests;
    license = licenses.mit;
  };

}
