{ stdenv, buildPythonPackage, isPy3k, fetchPypi, requests, zeroconf, netifaces, pytest }:

buildPythonPackage rec {
  pname = "netdisco";
  version = "2.7.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rkaz9377f4ldxcqxcmcc9hwdv5dda8nl7vrnp2pj3ppivq5629w";
  };

  propagatedBuildInputs = [ requests zeroconf netifaces ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Python library to scan local network for services and devices";
    homepage = "https://github.com/home-assistant/netdisco";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
