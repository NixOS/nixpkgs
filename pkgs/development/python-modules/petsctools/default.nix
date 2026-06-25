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

buildPythonPackage (finalAttrs: {
  pname = "petsctools";
  version = "2026.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "petsctools";
    tag = finalAttrs.version;
    hash = "sha256-IMDPjhyehOkyifSJ7nOJQbZu21w6Xyyz9fv/WLDpEgQ=";
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
  ++ finalAttrs.passthru.optional-dependencies.petsc4py;

  disabledTests = [
    # Expects a double slash when PETSC_ARCH is empty.
    "test_get_petsc_dirs"
  ];

  meta = {
    homepage = "https://github.com/firedrakeproject/petsctools";
    description = "Pythonic extensions for petsc4py and slepc4py";
    changelog = "https://github.com/firedrakeproject/petsctools/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
