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

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Fo8fpTlIBH7/5PFNU/wdq1AZLios94VXA/Em9GnqEfQ=";
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
    maintainers = with maintainers; [ desiderius ];
  };
}
