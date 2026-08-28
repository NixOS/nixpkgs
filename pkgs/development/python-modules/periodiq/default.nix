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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11,<0.12" "uv_build"
  '';

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
    homepage = "https://gitlab.com/bersace/periodiq";
    changelog = "https://gitlab.com/bersace/periodiq/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ traxys ];
    mainProgram = "periodiq";
  };
}
