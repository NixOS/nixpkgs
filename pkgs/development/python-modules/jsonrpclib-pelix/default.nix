{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pimyq95w99ik5av96j0n9i6n12mr9kk0y28jnrq0555d7hmii8r";
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = with lib; {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = https://pypi.python.org/pypi/jsonrpclib-pelix/;
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ moredread ];
  };
}
