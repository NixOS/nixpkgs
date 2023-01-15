{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, redis
, redis-server
}:

buildPythonPackage rec {
  pname = "logutils";
  version = "0.3.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc058a25d5c209461f134e1f03cab637d66a7a5ccc12e593db56fbb279899a82";
  };

  checkInputs = [
    pytestCheckHook
    redis
    redis-server
  ];

  disabledTests = [
    # https://bitbucket.org/vinay.sajip/logutils/issues/4/035-pytest-test-suite-warnings-and-errors
    "test_hashandlers"
  ];

  disabledTestPaths = lib.optionals (stdenv.isDarwin) [
    # Exception: unable to connect to Redis server
    "tests/test_redis.py"
  ];

  meta = with lib; {
    description = "Logging utilities";
    homepage = "https://bitbucket.org/vinay.sajip/logutils/";
    license = licenses.bsd0;
  };
}
