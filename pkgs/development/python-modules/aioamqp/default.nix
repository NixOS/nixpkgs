{ lib, buildPythonPackage, fetchPypi, pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioamqp";
  version = "0.14.0";

  meta = {
    homepage = https://github.com/polyconseil/aioamqp;
    description = "AMQP implementation using asyncio";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "eef5c23a7fedee079d8326406f5c7a5725dfe36c359373da3499fffa16f79915";
  };

  disabled = pythonOlder "3.3";
}
