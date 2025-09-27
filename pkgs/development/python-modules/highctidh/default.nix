{
  lib,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
  fetchFromGitea,
}:
buildPythonPackage rec {
  pname = "highctidh";
  version = "1.0.2024050500";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "vula";
    repo = "highctidh";
    tag = "v${version}";
    hash = "sha256-Ovdq1ICyMdTzmFUvVu+U0W6N/Q6IFfbsckMMYRzT3wg=";
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
