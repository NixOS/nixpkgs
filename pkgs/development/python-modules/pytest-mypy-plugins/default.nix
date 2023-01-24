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
  version = "1.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7Qow315zuZB6BNIIm6QR9ZMFH6E/VSp2vRBpONlqYhM=";
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
