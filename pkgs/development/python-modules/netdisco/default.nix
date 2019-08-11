{ stdenv, buildPythonPackage, isPy3k, fetchPypi, requests, zeroconf, netifaces, pytest }:

buildPythonPackage rec {
  pname = "netdisco";
  version = "2.6.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b3aca14a1807712a053f11fd80dc251dd821ee4899aefece515287981817762";
  };

  propagatedBuildInputs = [ requests zeroconf netifaces ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Python library to scan local network for services and devices";
    homepage = https://github.com/home-assistant/netdisco;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
