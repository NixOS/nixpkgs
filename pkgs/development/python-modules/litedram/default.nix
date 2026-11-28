{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # A DDR3/DDR4 rtt_nom setting was stored where the init sequence does not read it.
    (fetchpatch {
      url = "https://github.com/enjoy-digital/litedram/commit/e7c7fc5ea61422b83ed236e12450417d97a1b69f.patch";
      hash = "sha256-8PJAEBvnVmQx4ID8iu5ERTMAvBIRdfKKwaSA7h1Vl/E=";
    })
  ];

  # These build boards from litex-boards, which depends on litedram; a deselect would also drop
  # test_ddr3_dll_off and test_ddr3_electrical_settings, whose names start the same.
  postPatch = ''
    for t in sdr ddr3 ddr4; do
      substituteInPlace test/test_init.py \
        --replace-fail "    def test_$t(self):" "    @unittest.skip('needs litex-boards')
        def test_$t(self):"
    done
  '';

  build-system = [ setuptools ];

  dependencies = [
    litex
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Need a VexRiscv CPU package, or Verilator and pexpect.
    "test/test_examples.py"
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
