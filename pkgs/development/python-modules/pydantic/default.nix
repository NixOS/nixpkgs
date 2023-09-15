{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, cython
, hatchling
, hatch-fancy-pypi-readme

# build
, libxcrypt

# dependencies
, typing-extensions
, annotated-types
, pydantic-core

# optional-dependencies
, email-validator

# tests
, dirty-equals
, faker
, pytestCheckHook
, pytest-benchmark
, pytest-examples
, pytest-mock
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-toqrWg8bYzc3UmvG/YmXawfmT8nqaA9fxy24k1cdj+M=";
  };

  buildInputs = lib.optionals (pythonOlder "3.9") [
    libxcrypt
  ];

  nativeBuildInputs = [
    cython
    hatchling
    hatch-fancy-pypi-readme
  ];

  propagatedBuildInputs = [
    annotated-types
    typing-extensions
    pydantic-core
  ];

  passthru.optional-dependencies = {
    email = [
      email-validator
    ];
  };

  pythonImportsCheck = [
    "pydantic"
  ];

  nativeCheckInputs = [
    dirty-equals
    faker
    pytest-benchmark
    pytest-examples
    pytest-mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "--benchmark-disable"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
