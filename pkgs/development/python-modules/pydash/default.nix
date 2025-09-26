{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  invoke,
  mock,
  pytest7CheckHook,
  pytest-cov-stub,
  pythonOlder,
  setuptools,
  sphinx-rtd-theme,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pydash";
  version = "8.0.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dgilland";
    repo = "pydash";
    tag = "v${version}";
    hash = "sha256-u8vLE0kjsnV2HNt3N3kmnaabgQzW3FcH4qxycNdv1Ls=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    invoke
    mock
    pytest7CheckHook
    pytest-cov-stub
    sphinx-rtd-theme
  ];

  pythonImportsCheck = [ "pydash" ];

  disabledTestPaths = [
    # Disable mypy testing
    "tests/pytest_mypy_testing/"
  ];

  meta = with lib; {
    description = "Python utility libraries for doing stuff in a functional way";
    homepage = "https://pydash.readthedocs.io";
    changelog = "https://github.com/dgilland/pydash/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
