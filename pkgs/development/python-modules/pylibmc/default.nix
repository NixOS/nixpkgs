{ lib
, buildPythonPackage
, cyrus_sasl
, fetchPypi
, libmemcached
, pythonOlder
, zlib
}:

buildPythonPackage rec {
  pname = "pylibmc";
  version = "1.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7vpGEVU3q61l++LgMqzRs0Y9m/njNa9LCRbfTk0yBuA=";
  };

  buildInputs = [
    cyrus_sasl
    libmemcached
    zlib
  ];

  setupPyBuildFlags = [
    "--with-sasl2"
  ];

  # Requires an external memcached server running
  doCheck = false;

  pythonImportsCheck = [
    "pylibmc"
  ];

  meta = with lib; {
    description = "Quick and small memcached client for Python";
    homepage = "http://sendapatch.se/projects/pylibmc/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
