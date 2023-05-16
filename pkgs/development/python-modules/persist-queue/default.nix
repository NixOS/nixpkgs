{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
<<<<<<< HEAD
, nose2
, msgpack
, cbor2
=======
, msgpack
, nose2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "persist-queue";
<<<<<<< HEAD
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4ZONOsbZthaSwRX43crajZox8iUGeCWF45WIpB7Ppao=";
=======
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vapNz8SyCpzh9cttoxFrbLj+N1J9mR/SQoVu8szNIY4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  disabled = pythonOlder "3.6";

  nativeCheckInputs = [
<<<<<<< HEAD
    nose2
    msgpack
    cbor2
=======
    msgpack
    nose2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
