{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  petsc4py,
  slepc4py,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "petsctools";
  version = "2025.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "petsctools";
    tag = version;
    hash = "sha256-DC0jFybDEacA6otYvID5DfbUe1ANz5W4UmPXCSsRvOo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    packaging
  ];

  optional-dependencies = {
    petsc4py = [ petsc4py ];
    slepc4py = [ slepc4py ];
  };

  pythonImportsCheck = [
    "petsctools"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ optional-dependencies.petsc4py;

  meta = {
    homepage = "https://github.com/firedrakeproject/petsctools";
    description = "Pythonic extensions for petsc4py and slepc4py";
    changelog = "https://github.com/firedrakeproject/petsctools/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
