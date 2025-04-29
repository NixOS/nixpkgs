{
  lib,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
  fetchgit,
}:
buildPythonPackage rec {
  pname = "highctidh";
  version = "1.0.2024060500";
  pyproject = true;

  src = fetchgit {
    url = "https://codeberg.org/vula/highctidh";
    rev = "v${version}";
    hash = "sha256-TyD5KzUz89RBxsSZeJYOkIzD29DF0BjizpMnsTpFOHI=";
  };

  sourceRoot = "${src.name}/src";

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
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
