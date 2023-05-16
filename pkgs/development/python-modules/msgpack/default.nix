{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "msgpack";
<<<<<<< HEAD
  version = "1.0.5";
=======
  version = "1.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-wHVUQoTq3Fzdxw9HVzMdmdy8FrK71ISdFfiq5M820xw=";
=======
    hash = "sha256-9dhpwY8DAgLrQS8Iso0q/upVPWYTruieIA16yn7wH18=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "msgpack"
  ];

  meta = with lib;  {
    description = "MessagePack serializer implementation";
    homepage = "https://github.com/msgpack/msgpack-python";
<<<<<<< HEAD
    changelog = "https://github.com/msgpack/msgpack-python/blob/v${version}/ChangeLog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
=======
    changelog = "https://github.com/msgpack/msgpack-python/blob/master/ChangeLog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
