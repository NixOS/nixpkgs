{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  more-itertools,
  numpy,
  ase,
  gemmi,
  pycifrw,
  pytest-doctestplus,
  pytestCheckHook,
  sympy,
}:

buildPythonPackage (finalAttrs: {
  pname = "parsnip";
  version = "0.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "parsnip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A1YoTBRN3ukcueUso5P2zPZ/pxu25k9h6aI7+AQvr1Q=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    more-itertools
    numpy
  ];

  nativeCheckInputs = [
    ase
    gemmi
    pycifrw
    pytest-doctestplus
    pytestCheckHook
    sympy
  ];

  pythonImportsCheck = [
    "parsnip"
  ];

  disabledTestPaths = [
    # Don't test docs
    "doc/source/"
  ];

  meta = {
    description = "Lightweight, performant library for parsing CIF files in Python";
    homepage = "https://github.com/glotzerlab/parsnip";
    changelog = "https://github.com/glotzerlab/parsnip/blob/${finalAttrs.src.tag}/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
