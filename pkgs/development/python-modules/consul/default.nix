{ stdenv, buildPythonPackage, fetchPypi
, requests, six, pytest }:

buildPythonPackage rec {
  pname = "python-consul";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef0b7c8a2d8efba5f9602f45aadbe5035e22a511d245624ed732af81223a6571";
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
