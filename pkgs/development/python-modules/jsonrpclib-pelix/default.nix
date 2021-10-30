{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "0.4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6f376c72ec1c0dfd69fcc2721d711f6ca1fe22bf71f99e6884c5e43e9b58c95";
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = with lib; {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = "https://pypi.python.org/pypi/jsonrpclib-pelix/";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
