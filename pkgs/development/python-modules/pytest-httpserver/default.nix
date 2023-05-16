{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, requests
, toml
, werkzeug
}:

buildPythonPackage rec {
  pname = "pytest-httpserver";
<<<<<<< HEAD
  version = "1.0.7";
=======
  version = "1.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "csernazs";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-bjysG+7niSUBl8YMWR8pr7oOz9GDbSfq3PeloYBkq3s=";
=======
    hash = "sha256-LY5Ur0cIcsNrgvyQlY2E479ZzRcuwqTuiT2MtRupVcs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    werkzeug
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
    toml
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_wait_raise_assertion_false" # racy
  ];

  pythonImportsCheck = [
    "pytest_httpserver"
  ];

  meta = with lib; {
    description = "HTTP server for pytest to test HTTP clients";
    homepage = "https://www.github.com/csernazs/pytest-httpserver";
    changelog = "https://github.com/csernazs/pytest-httpserver/blob/${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
