{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "340915c17ebef7451948341542bf4789fc8d8c9fe604e86f00b722b6074a89f0";
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = with lib; {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = "https://pypi.python.org/pypi/jsonrpclib-pelix/";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
