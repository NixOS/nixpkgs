{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, hypothesis
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ifaddr
, lxml
, poetry-core
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "pywemo";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "0.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-+AdNT7ClT8JkYLkwk+IVNWgXGS04WNtENOtqmbjv7nQ=";
=======
    hash = "sha256-mrLZ8W7imM/ysJhd4OcqZFzx2z/KG8k5bOPFb4ldYzE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    ifaddr
    requests
    urllib3
    lxml
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    hypothesis
=======
  nativeCheckInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pywemo"
  ];

  meta = with lib; {
    description = "Python module to discover and control WeMo devices";
    homepage = "https://github.com/pywemo/pywemo";
    changelog = "https://github.com/pywemo/pywemo/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
