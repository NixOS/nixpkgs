{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  invoke,
  mock,
  pytest7CheckHook,
  pythonOlder,
  setuptools,
  sphinx-rtd-theme,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pydash";
  version = "8.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dgilland";
    repo = "pydash";
    rev = "refs/tags/v${version}";
    hash = "sha256-4zNljz0U/iQd2DMC43qkdOY/mwtPlizgLmoaB7BVmxw=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
    sed -i "/--no-cov/d" pyproject.toml
  '';

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    invoke
    mock
    pytest7CheckHook
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
    maintainers = with maintainers; [ ma27 ];
  };
}
