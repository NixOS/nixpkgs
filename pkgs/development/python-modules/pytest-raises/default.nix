{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pytest
, pytestCheckHook
, pythonOlder
=======
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pytest-raises";
  version = "0.11";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Lemmons";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-wmtWPWwe1sFbWSYxs5ZXDUZM1qvjRGMudWdjQeskaz0=";
  };

  buildInputs = [
    pytest
  ];

=======
    rev = version;
    sha256 = "0gbb4kml2qv7flp66i73mgb4qihdaybb6c96b5dw3mhydhymcsy2";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "pytest_raises"
  ];

  disabledTests = [
    # Failed: nomatch: '*::test_pytest_mark_raises_unexpected_exception FAILED*'
    # https://github.com/Lemmons/pytest-raises/issues/30
    "test_pytest_mark_raises_unexpected_exception"
    "test_pytest_mark_raises_unexpected_match"
    "test_pytest_mark_raises_parametrize"
  ];
=======
  pythonImportsCheck = [ "pytest_raises" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "An implementation of pytest.raises as a pytest.mark fixture";
    homepage = "https://github.com/Lemmons/pytest-raises";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
