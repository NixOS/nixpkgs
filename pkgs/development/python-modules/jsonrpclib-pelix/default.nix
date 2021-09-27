{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "768e0a48249fbc6387564bb18ef347fd5db5b6ac74b86d5b1c009855850b14b3";
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = with lib; {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = "https://pypi.python.org/pypi/jsonrpclib-pelix/";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
