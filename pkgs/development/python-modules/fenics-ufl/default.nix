{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fenics-ufl";
  version = "2026.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fenics";
    repo = "ufl";
    tag = finalAttrs.version;
    hash = "sha256-h4J8BDAQjn2dGTWwsXEEarzA0+wPtHhnrwi/hTFFt1w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [
    "ufl"
    "ufl.algorithms"
    "ufl.core"
    "ufl.corealg"
    "ufl.formatting"
    "ufl.utils"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://fenicsproject.org";
    downloadPage = "https://github.com/fenics/ufl";
    description = "Unified Form Language";
    changelog = "https://github.com/fenics/ufl/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
