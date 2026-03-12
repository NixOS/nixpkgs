{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "riscv-model";
  version = "0.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wallento";
    repo = "riscv-python-model";
    tag = finalAttrs.version;
    hash = "sha256-H4N9Z8aK/xV5gCCdsL+oiR+XQfYtCfBRBGLqvuztX+o=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "riscvmodel"
    "riscvmodel.insn"
    "riscvmodel.variant"
  ];

  meta = {
    description = "Formal RISC-V architecture model in Python";
    homepage = "https://github.com/wallento/riscv-python-model";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gonsolo ];
    platforms = lib.platforms.all;
  };
})
