{
  buildPythonPackage,
  hatchling,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "jsonrpclib-pelix";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.4.3.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;
  build-system = [ hatchling ];

  src = fetchPypi {
    pname = "jsonrpclib_pelix";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-Wx6hTabjcdur7bGr7QqLoc9ZZCg1DNnQGI88bGyO94Q=";
=======
    hash = "sha256-6C1vTakHp9ER75P9I2HIwgt50ki+T+mWeOCGJqqPy+8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  doCheck = false; # test_suite="tests" in setup.py but no tests in pypi.

  meta = {
    description = "JSON RPC client library - Pelix compatible fork";
    homepage = "https://pypi.python.org/pypi/jsonrpclib-pelix/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
