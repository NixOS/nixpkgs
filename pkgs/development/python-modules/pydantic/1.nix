{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
  typing-extensions,

  # optional-dependencies
  python-dotenv,
  email-validator,

  # tests
  distutils,
  pytest-mock,
  pytest7CheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "1.10.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    tag = "v${version}";
    hash = "sha256-0kwqJsay+4xh+jgDStNciRPJmuqm8GzA+6ble4K4HuI=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    dotenv = [ python-dotenv ];
    email = [ email-validator ];
  };

  nativeCheckInputs = [
    distutils
    pytest-mock
    pytest7CheckHook
    writableTmpDirAsHomeHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  enableParallelBuilding = true;

  pythonImportsCheck = [ "pydantic" ];

  meta = {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/v${version}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wd15 ];
  };
}
