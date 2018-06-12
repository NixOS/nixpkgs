{ stdenv, fetchPypi, buildPythonPackage
, urllib3, idna, chardet, certifi
, pytest }:

buildPythonPackage rec {
  pname = "requests";
  version = "2.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc408268d0e21589bcc2b2c248e42932b8c4d112f499c12c92e99e2178a6134c";
  };

  outputs = [ "out" "dev" ];

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
