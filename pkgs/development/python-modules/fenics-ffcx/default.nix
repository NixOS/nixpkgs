{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  cffi,
  fenics-ufl,
  fenics-basix,
  sympy,
  numba,
  pytestCheckHook,
  addBinToPathHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fenics-ffcx";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fenics";
    repo = "ffcx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pAnoCLf1ObJ2jDOdQ0cr3qu3z+rNeAVFPnvegp/KqeM=";
  };

  pythonRelaxDeps = [
    "fenics-ufl"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    cffi
    setuptools
    fenics-ufl
    fenics-basix
  ];

  pythonImportsCheck = [
    "ffcx"
  ];

  nativeCheckInputs = [
    sympy
    numba
    pytestCheckHook
    addBinToPathHook
  ];

  meta = {
    homepage = "https://fenicsproject.org";
    downloadPage = "https://github.com/fenics/ffcx";
    description = "FEniCSx Form Compiler";
    changelog = "https://github.com/fenics/ffcx/releases/tag/v${finalAttrs.version}";
    mainProgram = "ffcx";
    license = with lib.licenses; [
      unlicense
      lgpl3Plus
    ];
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
