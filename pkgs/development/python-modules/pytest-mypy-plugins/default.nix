{ lib
, buildPythonPackage
, chevron
, decorator
, fetchFromGitHub
, mypy
, pytest
, pytestCheckHook
, pythonOlder
, pyyaml
, regex
}:

buildPythonPackage rec {
  pname = "pytest-mypy-plugins";
<<<<<<< HEAD
  version = "1.11.1";
=======
  version = "1.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-UlNjqloAl0Qmy3EQ73e+KmsHeJN3eBkkBJxCehpOs48=";
=======
    hash = "sha256-7Qow315zuZB6BNIIm6QR9ZMFH6E/VSp2vRBpONlqYhM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    chevron
    pyyaml
    mypy
    decorator
    regex
  ];

  nativeCheckInputs = [
    mypy
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [
    "pytest_mypy_plugins"
  ];

  disabledTests = [
    # ...TypecheckAssertionError: Invalid output:
    "with_out"
    "add_mypypath_env_var_to_package_searc"
    "error_case"
    "skip_if_false"
  ];

  meta = with lib; {
    description = "Pytest plugin for testing mypy types, stubs, and plugins";
    homepage = "https://github.com/TypedDjango/pytest-mypy-plugins";
    changelog = "https://github.com/typeddjango/pytest-mypy-plugins/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
