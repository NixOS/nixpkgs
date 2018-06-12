{ stdenv, buildPythonPackage, fetchPypi
, requests, six, pytest }:

buildPythonPackage rec {
  pname = "python-consul";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0feb7a14b6869bbfa9eb4868e823f040e3642b84e80c39ffdff3a8b7fd7017c4";
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
