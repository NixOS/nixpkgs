{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jsonrpclib_pelix";
    inherit version;
    hash = "sha256-NTtmcHwPxCY+3I/Wu9Rxt67egjqD5NvxYUsMg67iDxg=";
  };

  build-system = [ setuptools ];

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  pythonImportsCheck = [ "jsonrpclib" ];

  meta = {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = "https://pypi.org/project/jsonrpclib-pelix/";
    changelog = "https://github.com/tcalmant/jsonrpclib/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
