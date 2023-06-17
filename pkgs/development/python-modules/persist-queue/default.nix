{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, msgpack
, nose2
}:

buildPythonPackage rec {
  pname = "persist-queue";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vapNz8SyCpzh9cttoxFrbLj+N1J9mR/SQoVu8szNIY4=";
  };

  disabled = pythonOlder "3.6";

  nativeCheckInputs = [
    msgpack
    nose2
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
