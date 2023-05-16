{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dockerfile-parse";
<<<<<<< HEAD
  version = "2.0.1";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-MYTM3FEyIZg+UDrADhqlBKKqj4Tl3mc8RrC27umex7w=";
=======
    hash = "sha256-If59UQZC8rYamZ1Fw9l0X5UOEf5rokl1Vbj2N4K3jkU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dockerfile_parse"
  ];

  disabledTests = [
    # python-dockerfile-parse.spec is not present
    "test_all_versions_match"
  ];

  meta = with lib; {
    description = "Library for parsing Dockerfile files";
    homepage = "https://github.com/DBuildService/dockerfile-parse";
    changelog = "https://github.com/containerbuildsystem/dockerfile-parse/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
