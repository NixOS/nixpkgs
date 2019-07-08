{ lib, buildPythonPackage, fetchPypi, pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioamqp";
  version = "0.12.0";

  meta = {
    homepage = https://github.com/polyconseil/aioamqp;
    description = "AMQP implementation using asyncio";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "17vrl6jajr81bql7kjgq0zkxy225px97z4g9wmbhbbnvzn1p92c0";
  };

  disabled = pythonOlder "3.3";
}
