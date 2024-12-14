{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  loguru,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "python-utils";
  version = "3.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ZmCT41VMz8BkIqF8Od5PqteyXToA4xASs0qCPD0cNc8=";
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
  ] ++ optional-dependencies.loguru;

  pythonImportsCheck = [ "python_utils" ];

  pytestFlagsArray = [ "_python_utils_tests" ];

  disabledTests = [
    # Flaky tests
    "test_timeout_generator"
  ];

  meta = with lib; {
    description = "Module with some convenient utilities";
    homepage = "https://github.com/WoLpH/python-utils";
    changelog = "https://github.com/wolph/python-utils/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
