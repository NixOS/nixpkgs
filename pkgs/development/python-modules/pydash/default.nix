{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, invoke
, mock
, pytestCheckHook
, pythonOlder
, setuptools
, sphinx-rtd-theme
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pydash";
  version = "7.0.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dgilland";
    repo = "pydash";
    rev = "refs/tags/v${version}";
    hash = "sha256-zwtUdP2fFFE5X0SDkBDetAQbKnZ1v24DGdzN3fQLa0A=";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
    sed -i "/--no-cov/d" setup.cfg
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [
    invoke
    mock
    pytestCheckHook
    sphinx-rtd-theme
  ];

  pythonImportsCheck = [
    "pydash"
  ];

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
