{ stdenv, buildPythonPackage, isPy3k, fetchPypi, requests, zeroconf, netifaces, pytest }:

buildPythonPackage rec {
  pname = "netdisco";
  version = "2.2.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5e810721a266660f7f90fc43f12c4635ec95c3db87d9e30ca408bb922cb1007";
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
