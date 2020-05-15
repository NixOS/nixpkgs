{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "006yvxw6xv6qzcqpxm8jcf21gmdn0z4vp8njdbvk023mmq05k3h4";
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = with lib; {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = "https://pypi.python.org/pypi/jsonrpclib-pelix/";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
