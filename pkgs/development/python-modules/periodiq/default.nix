{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  uv-build,
  dramatiq,
  pendulum,
  setuptools,
  pytest-mock,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "periodiq";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "bersace";
    repo = "periodiq";
    tag = "v${version}";
    hash = "sha256-XYQ0cR0gdiX7GePqpMDG/Ml0CK+SBcNbsNB99FZ/D3I=";
  };

  build-system = [ uv-build ];

  dependencies = [
    dramatiq
    pendulum
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    versionCheckHook
  ];

  enabledTestPaths = [ "tests/unit" ];

  pythonImportsCheck = [ "periodiq" ];

  meta = {
    description = "Simple Scheduler for Dramatiq Task Queue";
    mainProgram = "periodiq";
    homepage = "https://gitlab.com/bersace/periodiq";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ traxys ];
  };
}
