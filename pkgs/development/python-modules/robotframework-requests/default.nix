{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, robotframework
, lxml
, requests
}:

buildPythonPackage rec {
  version = "0.6.6";
  pname = "robotframework-requests";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01b6d02052349663b7faae5e9363877b1e5ea1f181bd52b1a29df3b03a348bcf";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml requests ];

  meta = with stdenv.lib; {
    description = "Robot Framework keyword library wrapper around the HTTP client library requests";
    homepage = "https://github.com/bulkan/robotframework-requests";
    license = licenses.mit;
  };

}
