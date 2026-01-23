{
  buildPythonPackage,
  hatchling,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "1.0.0";
  pyproject = true;
  build-system = [ hatchling ];

  src = fetchPypi {
    pname = "jsonrpclib_pelix";
    inherit version;
    hash = "sha256-Wx6hTabjcdur7bGr7QqLoc9ZZCg1DNnQGI88bGyO94Q=";
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = "https://pypi.python.org/pypi/jsonrpclib-pelix/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
