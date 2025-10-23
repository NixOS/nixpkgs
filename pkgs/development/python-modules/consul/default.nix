{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  six,
  pytest,
}:

buildPythonPackage rec {
  pname = "python-consul";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "168f1fa53948047effe4f14d53fc1dab50192e2a2cf7855703f126f469ea11f4";
  };

  buildInputs = [
    requests
    six
    pytest
  ];

  # No tests distributed. https://github.com/cablehead/python-consul/issues/133
  doCheck = false;

  meta = with lib; {
    description = "Python client for Consul (https://www.consul.io/)";
    homepage = "https://github.com/cablehead/python-consul";
    license = licenses.mit;
  };
}
