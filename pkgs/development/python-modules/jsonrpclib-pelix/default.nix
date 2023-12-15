{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "0.4.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6eCzPvqPog2BfdeN/Z5M2zlnyKXTy1p4O+HugcSonHw=";
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = with lib; {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = "https://pypi.python.org/pypi/jsonrpclib-pelix/";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
