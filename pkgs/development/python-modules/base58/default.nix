{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pyhamcrest
=======
, py
, pyhamcrest
, pytest-benchmark
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "base58";
  version = "2.1.1";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c5d0cb3f5b6e81e8e35da5754388ddcc6d0d14b6c6a132cb93d69ed580a7278c";
  };

  nativeCheckInputs = [
<<<<<<< HEAD
    pyhamcrest
    pytestCheckHook
  ];

  disabledTests = [
    # avoid dependency on pytest-benchmark
    "test_decode_random"
    "test_encode_random"
  ];

=======
    py
    pyhamcrest
    pytest-benchmark
    pytestCheckHook
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "base58" ];

  meta = with lib; {
    description = "Base58 and Base58Check implementation";
    homepage = "https://github.com/keis/base58";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
