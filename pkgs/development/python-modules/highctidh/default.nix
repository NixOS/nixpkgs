{
  lib,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
  fetchFromGitea,
  gitUpdater,
}:
buildPythonPackage rec {
  pname = "highctidh";
  version = "1.0.2025051200";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "vula";
    repo = "highctidh";
    tag = "v${version}";
    hash = "sha256-wGJv9UHAFfCOpTrr8THVk0DC+JUtj3gYYOf6o3EaSqg=";
  };

  sourceRoot = "${src.name}/src";

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "highctidh"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Fork of high-ctidh as as a portable shared library with Python bindings";
    homepage = "https://codeberg.org/vula/highctidh";
    license = lib.licenses.publicDomain;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [
      lorenzleutgeb
      mightyiam
    ];
  };
}
