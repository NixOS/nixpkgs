{ lib, fetchPypi, buildPythonPackage
, urllib3, idna, chardet, certifi
, pytest }:

buildPythonPackage rec {
  pname = "requests";
  version = "2.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y6mb8c0ipd64d5axq2p368yxndp3f966hmabjka2q2a5y9hn6kz";
  };

  nativeBuildInputs = [ pytest ];
  propagatedBuildInputs = [ urllib3 idna chardet certifi ];
  # sadly, tests require networking
  doCheck = false;

  meta = with lib; {
    description = "An Apache2 licensed HTTP library, written in Python, for human beings";
    homepage = "http://docs.python-requests.org/en/latest/";
    license = licenses.asl20;
  };
}
