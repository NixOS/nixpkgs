{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  pname = "lru-dict";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

<<<<<<< HEAD
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E8VngvGdaN302NsBcAQRkoWWFlFMcGsSbQ3y7HKhG9c=";
=======
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h4vI70Bz5c+5U9/Bz0WF20HouBTAEGq9400A7g0LMRU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "lru"
  ];

  meta = with lib; {
    description = "Fast and memory efficient LRU cache for Python";
    homepage = "https://github.com/amitdev/lru-dict";
<<<<<<< HEAD
    changelog = "https://github.com/amitdev/lru-dict/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
