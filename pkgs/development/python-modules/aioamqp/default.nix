{ lib, buildPythonPackage, fetchPypi, isPy33, pythonOlder,
  asyncio
}:

buildPythonPackage rec {
  pname = "aioamqp";
  version = "0.11.0";

  meta = {
    homepage = https://github.com/polyconseil/aioamqp;
    description = "AMQP implementation using asyncio";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f1eb9e0f1b7c7e21a3a6ca498c3daafdfc3e95b4a1a0633fd8d6ba2dfcab777";
  };

  buildInputs = lib.optionals isPy33 [ asyncio ];

  disabled = pythonOlder "3.3";
}
