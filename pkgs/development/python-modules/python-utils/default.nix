{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  loguru,
  pytest-asyncio,
  pytest-cov-stub,
  pytest9_1CheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "python-utils";
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = "python-utils";
    tag = "v${version}";
    hash = "sha256-09srwxTzDJ12MB8qCyt9SXa9zB+nWRx+x9wWjEUIngE=";
  };

  build-system = [ uv-build ];

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    loguru = [ loguru ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest9_1CheckHook
  ]
  ++ optional-dependencies.loguru;

  pythonImportsCheck = [ "python_utils" ];

  enabledTestPaths = [ "_python_utils_tests" ];

  disabledTests = [
    # Flaky tests
    "test_timeout_generator"
  ];

  meta = {
    description = "Module with some convenient utilities";
    homepage = "https://github.com/WoLpH/python-utils";
    changelog = "https://github.com/wolph/python-utils/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
