{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  uv-build,
  dramatiq,
  pendulum,
  pytest-mock,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "periodiq";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "bersace";
    repo = "periodiq";
    tag = "v${finalAttrs.version}";
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    versionCheckHook
  ];

  pythonImportsCheck = [ "periodiq" ];

  meta = {
    description = "Simple Scheduler for Dramatiq Task Queue";
    homepage = "https://gitlab.com/bersace/periodiq";
    changelog = "https://gitlab.com/bersace/periodiq/-/blob/${finalAttrs.src.tag}/CHANGELOG.md?ref_type=tags";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ traxys ];
    mainProgram = "periodiq";
  };
})
