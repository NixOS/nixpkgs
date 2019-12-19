{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "getmac";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s6ka96nr549k9jqpyqaj5vi18465qcmi1vsl37lhql5f45x40fm";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/GhostofGoes/getmac";
    description = "Pure-Python package to get the MAC address of network interfaces and hosts on the local network.";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
