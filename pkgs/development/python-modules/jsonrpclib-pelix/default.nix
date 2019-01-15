{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14d288d1b3d3273cf96a729dd21a2470851c4962be8509f3dd62f0137ff90339";
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = with lib; {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = https://pypi.python.org/pypi/jsonrpclib-pelix/;
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ moredread ];
  };
}
