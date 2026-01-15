{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  loguru,
  pytest-asyncio,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "python-utils";
  version = "3.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = "python-utils";
    tag = "v${version}";
    hash = "sha256-lzLzYI5jShfIwQqvfA8UtPjGawXE80ww7jb/gPzpeDo=";
  };

  postPatch = ''
    sed -i pytest.ini \
      -e '/--cov/d' \
      -e '/--mypy/d'
  '';

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    loguru = [ loguru ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
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
