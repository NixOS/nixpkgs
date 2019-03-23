{ stdenv, buildPythonPackage, isPy3k, fetchPypi, requests, zeroconf, netifaces, pytest }:

buildPythonPackage rec {
  pname = "netdisco";
  version = "2.5.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ecb9830ceed5cf8f2ccc5a9bbe02ca5f6851435f5315a5402f0123311f13b37";
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
