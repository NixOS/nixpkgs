{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  more-itertools,
  numpy,

  # tests
  ase,
  gemmi,
  gsd,
  pycifrw,
  pytest-doctestplus,
  pytestCheckHook,
  sympy,
}:

buildPythonPackage (finalAttrs: {
  pname = "parsnip";
  version = "1.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "parsnip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-27FEp+Z+Q4a2RR01YVmN7eUClpto8uUysp5mZWeKz7M=";
  };

  patches = [
    # Numpy 2.5 compatibility, see: https://github.com/glotzerlab/parsnip/pull/245
    (fetchpatch {
      url = "https://github.com/glotzerlab/parsnip/commit/41a6bd6e42ea212203d5ce5864c687927b834586.patch";
      includes = [
        # Other files are changelog & credits
        "parsnip/parsnip.py"
      ];
      hash = "sha256-Y91fITsPkmcct2tDsaHtNB8ct41IMtw1A+QnRwChc7k=";
    })
  ];

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
    gsd
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
