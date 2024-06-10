{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pyrabbit2";
  version = "1.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d27160cb35c096f0072df57307233d01b117a451236e136604a8e51be6f106c0";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "Pythonic interface to the RabbitMQ Management HTTP API";
    homepage = "https://github.com/deslum/pyrabbit2";
    license = licenses.mit;
    maintainers = [ ];
  };
}
