{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  callPackage,
  hatch-fancy-pypi-readme,
  hatchling,
  annotated-types,
  pydantic-core,
  typing-extensions,
  email-validator,
  pythonOlder,
  pytestCheckHook,
  dirty-equals,
  pytest-examples,
  pytest-mock,
  faker,
}:
buildPythonPackage rec {
  pname = "pydantic";
  version = "2.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    rev = "v${version}";
    hash = "sha256-Nx6Jmx9UqpvG3gMWOarVG6Luxgmt3ToUbmDbGQTHQto=";
  };

  patches = [
    ./01-remove-benchmark-flags.patch
  ];

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [
    annotated-types
    pydantic-core
    typing-extensions
  ];

  passthru.optional-dependencies = {
    email = [
      email-validator
    ];
  };

  pythonImportsCheck = [ "pydantic" ];

  nativeCheckInputs = [
    pytestCheckHook
    dirty-equals
    pytest-mock
    pytest-examples
    faker
  ];

  disabledTestPaths = [
    "tests/benchmarks"
  ];

  meta = with lib; {
    description = "Data validation using Python type hints";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
