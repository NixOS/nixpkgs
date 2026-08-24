{
  buildPythonPackage,
  hatchling,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "1.2.0";
  pyproject = true;
  build-system = [ hatchling ];

  src = fetchPypi {
    pname = "jsonrpclib_pelix";
    inherit version;
    hash = "sha256-NTtmcHwPxCY+3I/Wu9Rxt67egjqD5NvxYUsMg67iDxg=";
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = "https://pypi.org/project/jsonrpclib-pelix/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
