{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysnooper";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "PySnooper";
<<<<<<< HEAD
    hash = "sha256-gQZp4WKiUKBm2GYuVzrbxa93DpN8W1V48ou3NV0chZs=";
=======
    hash = "sha256-0X3JHMoVk8ECMNzkXkax0/8PiRDww46UHt9roSYLOCA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysnooper"
  ];

  meta = with lib; {
    description = "A poor man's debugger for Python";
    homepage = "https://github.com/cool-RR/PySnooper";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
