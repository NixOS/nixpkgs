{
  buildPythonPackage,
  hatchling,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "0.4.3.4";
  pyproject = true;
  build-system = [ hatchling ];

  src = fetchPypi {
    pname = "jsonrpclib_pelix";
    inherit version;
    hash = "sha256-6C1vTakHp9ER75P9I2HIwgt50ki+T+mWeOCGJqqPy+8=";
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = "https://pypi.python.org/pypi/jsonrpclib-pelix/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
