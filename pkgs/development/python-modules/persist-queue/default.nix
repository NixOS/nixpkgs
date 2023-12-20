{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, nose2
, msgpack
, cbor2
}:

buildPythonPackage rec {
  pname = "persist-queue";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4ZONOsbZthaSwRX43crajZox8iUGeCWF45WIpB7Ppao=";
  };

  disabled = pythonOlder "3.6";

  nativeCheckInputs = [
    nose2
    msgpack
    cbor2
  ];

  checkPhase = ''
    runHook preCheck

    # Don't run MySQL tests, as they require a MySQL server running
    rm persistqueue/tests/test_mysqlqueue.py

    nose2

    runHook postCheck
  '';

  pythonImportsCheck = [ "persistqueue" ];

  meta = with lib; {
    description = "Thread-safe disk based persistent queue in Python";
    homepage = "https://github.com/peter-wangxu/persist-queue";
    license = licenses.bsd3;
    maintainers = with maintainers; [ huantian ];
  };
}
