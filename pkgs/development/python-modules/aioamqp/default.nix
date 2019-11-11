{ lib, buildPythonPackage, fetchPypi, pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioamqp";
  version = "0.13.0";

  meta = {
    homepage = https://github.com/polyconseil/aioamqp;
    description = "AMQP implementation using asyncio";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "ced0d2bb0054809b37b0636da34fc7cda23d66943fb5f9f0610555988cf347b2";
  };

  disabled = pythonOlder "3.3";
}
