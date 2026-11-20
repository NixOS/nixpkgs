{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  litex,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "litedram";
  version = "2026.08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enjoy-digital";
    repo = "litedram";
    tag = finalAttrs.version;
    hash = "sha256-AsySWooAyTV1L6ottZqOXklq6hp6MO8ZQ5Cg/rPi3t0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    litex
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Need a VexRiscv CPU package, litex-boards, or Verilator and pexpect.
    "test/test_examples.py"
    "test/test_init.py::TestInit::test_ddr3"
    "test/test_init.py::TestInit::test_ddr4"
    "test/test_init.py::TestInit::test_sdr"
    "test/test_lpddr4.py::VerilatorLPDDR4Tests"
    "test/test_lpddr5.py::VerilatorLPDDR5Tests"
  ];

  pythonImportsCheck = [
    "litedram"
    "litedram.gen"
  ];

  meta = {
    description = "Small footprint and configurable DRAM core";
    homepage = "https://github.com/enjoy-digital/litedram";
    changelog = "https://github.com/enjoy-digital/litedram/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ gonsolo ];
    mainProgram = "litedram_gen";
  };
})
