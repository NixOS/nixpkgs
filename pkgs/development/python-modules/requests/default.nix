{ stdenv, fetchPypi, buildPythonPackage
, urllib3, idna, chardet, certifi
, pytest }:

buildPythonPackage rec {
  pname = "requests";
  version = "2.21.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e";
  };

  nativeBuildInputs = [ pytest ];
  propagatedBuildInputs = [ urllib3 idna chardet certifi ];
  # sadly, tests require networking
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An Apache2 licensed HTTP library, written in Python, for human beings";
    homepage = http://docs.python-requests.org/en/latest/;
    license = licenses.asl20;
  };
}
