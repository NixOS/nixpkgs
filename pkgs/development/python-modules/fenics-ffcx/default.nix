{
  lib,
  stdenv,
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
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fenics";
    repo = "ffcx";
    tag = "v${version}";
    hash = "sha256-eAV//RLbrxyhqgbZ2DiR7qML7xfgPn0/Seh+2no0x8w=";
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

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=unused-command-line-argument";

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
