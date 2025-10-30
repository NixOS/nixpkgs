{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fenics-ufl";
  version = "2025.2.0.post0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fenics";
    repo = "ufl";
    tag = version;
    hash = "sha256-npNcI3iu9gfTKzHhhc/mkHDhiBe9+VNgahcxR1TF5nw=";
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
    changelog = "https://github.com/fenics/ufl/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
