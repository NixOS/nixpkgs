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

buildPythonPackage rec {
  pname = "fenics-ffcx";
  version = "0.10.1.post0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fenics";
    repo = "ffcx";
    tag = "v${version}";
    hash = "sha256-uV3sfK6tpdoVf+O/EYZw3yR1PdqkoXt4q66zwQ8h/Ks=";
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
    changelog = "https://github.com/fenics/ffcx/releases/tag/${src.tag}";
    mainProgram = "ffcx";
    license = with lib.licenses; [
      unlicense
      lgpl3Plus
    ];
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
