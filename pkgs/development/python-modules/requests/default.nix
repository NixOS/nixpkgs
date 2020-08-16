{ stdenv, fetchPypi, buildPythonPackage
, urllib3, idna, chardet, certifi
, pytest }:

buildPythonPackage rec {
  pname = "requests";
  version = "2.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b";
  };

  nativeBuildInputs = [ pytest ];
  propagatedBuildInputs = [ urllib3 idna chardet certifi ];
  # sadly, tests require networking
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An Apache2 licensed HTTP library, written in Python, for human beings";
    homepage = "http://docs.python-requests.org/en/latest/";
    license = licenses.asl20;
  };
}
