{ lib, buildPythonPackage, fetchPypi, isPy33, pythonOlder,
  asyncio
}:

buildPythonPackage rec {
  pname = "aioamqp";
  name = "${pname}-${version}";
  version = "0.10.0";

  meta = {
    homepage = https://github.com/polyconseil/aioamqp;
    description = "AMQP implementation using asyncio";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "0132921yy31ijb8w439zcz1gla4hiws4hx8zf6la4hjr01nsy666";
  };

  buildInputs = lib.optionals isPy33 [ asyncio ];

  disabled = pythonOlder "3.3";
}
