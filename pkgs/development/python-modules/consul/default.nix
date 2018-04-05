{ stdenv, buildPythonPackage, fetchPypi
, requests, six, pytest }:

buildPythonPackage rec {
  pname = "python-consul";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18gs5myk9wkkq5zvj0n0s68ngj3mrbdcifshxfj1j0bgb1km0wpm";
  };

  buildInputs = [ requests six pytest ];

  # No tests distributed. https://github.com/cablehead/python-consul/issues/133
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python client for Consul (https://www.consul.io/)";
    homepage = https://github.com/cablehead/python-consul;
    license = licenses.mit;
    maintainers = with maintainers; [ desiderius ];
  };
}
