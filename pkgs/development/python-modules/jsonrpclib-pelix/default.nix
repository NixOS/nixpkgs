{
  buildPythonPackage,
  hatchling,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "1.1.0";
  pyproject = true;
  build-system = [ hatchling ];

  src = fetchPypi {
    pname = "jsonrpclib_pelix";
    inherit version;
    hash = "sha256-N5o8mz3UeHJ0GVh6p88Uu2/w5kMB3swP+pj3EPa/7B4=";
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = "https://pypi.org/project/jsonrpclib-pelix/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
