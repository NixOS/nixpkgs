{ lib
, bleak
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "aranet4";
<<<<<<< HEAD
  version = "2.2.2";
=======
  version = "2.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Anrijs";
    repo = "Aranet4-Python";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-HiveHkGQUCvG4aqK2HSCbONObidT7yof4LzKSJPEOKU=";
=======
    hash = "sha256-5q4eOC9iuN8pUmDsiQ7OwEXkxi4KdL+bhGVjlQlTBAg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    bleak
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aranet4"
  ];

<<<<<<< HEAD
  disabledTests = [
    # Test compares rendered output
    "test_current_values"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Module to interact with Aranet4 devices";
    homepage = "https://github.com/Anrijs/Aranet4-Python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
