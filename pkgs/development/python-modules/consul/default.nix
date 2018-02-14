{ stdenv, buildPythonPackage, fetchPypi
, requests, six, pytest }:

buildPythonPackage rec {
  pname = "python-consul";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i0pf3yvga7kvzzkj378hhmn9qs0y0iyhs28xflvz6w6nqa7msqg";
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
