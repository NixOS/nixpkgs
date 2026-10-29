{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # tests
  ghdl,
  iverilog,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "myhdl";
  version = "0.11.51";
  pyproject = true;

  # No recent tags on GitHub
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nZEdYLRjk2rgS3byc4iu9oJazodnoNg63MBUMasGZiw=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    ghdl
    iverilog
    pytestCheckHook
  ];

  enabledTestPaths = [
    "myhdl/test"
  ];

  disabledTestPaths = [
    # myhdl.CosimulationError: Premature simulation end
    # ----------------------------- Captured stdout call -----------------------------
    # binaryOps.o: Program not runnable, 2 errors.
    # ----------------------------- Captured stderr call -----------------------------
    # ../../../../cosimulation/icarus/myhdl.vpi: Unable to find module file `../../../../cosimulation/icarus/myhdl.vpi' or `../../../../cosimulation/icarus/myhdl.vpi.vpi'.
    # tb_binaryOps.v:24: Error: System task/function $from_myhdl() is not defined by any module.
    # tb_binaryOps.v:29: Error: System task/function $to_myhdl() is not defined by any module.
    "myhdl/test/conversion/toVerilog/test_GrayInc.py"
    "myhdl/test/conversion/toVerilog/test_RandomScrambler.py"
    "myhdl/test/conversion/toVerilog/test_always_comb.py"
    "myhdl/test/conversion/toVerilog/test_beh.py"
    "myhdl/test/conversion/toVerilog/test_bin2gray.py"
    "myhdl/test/conversion/toVerilog/test_dec.py"
    "myhdl/test/conversion/toVerilog/test_edge.py"
    "myhdl/test/conversion/toVerilog/test_fsm.py"
    "myhdl/test/conversion/toVerilog/test_hec.py"
    "myhdl/test/conversion/toVerilog/test_inc.py"
    "myhdl/test/conversion/toVerilog/test_loops.py"
    "myhdl/test/conversion/toVerilog/test_misc.py"
    "myhdl/test/conversion/toVerilog/test_ops.py"
    "myhdl/test/conversion/toVerilog/test_ram.py"
    "myhdl/test/conversion/toVerilog/test_rom.py"
  ];

  disabledTests = [
    # myhdl.CosimulationError: Premature simulation end
    # ----------------------------- Captured stdout call -----------------------------
    # binaryOps.o: Program not runnable, 2 errors.
    # ----------------------------- Captured stderr call -----------------------------
    # ../../../../cosimulation/icarus/myhdl.vpi: Unable to find module file `../../../../cosimulation/icarus/myhdl.vpi' or `../../../../cosimulation/icarus/myhdl.vpi.vpi'.
    # tb_binaryOps.v:24: Error: System task/function $from_myhdl() is not defined by any module.
    # tb_binaryOps.v:29: Error: System task/function $to_myhdl() is not defined by any module.
    "TestInc"
    "TestInfer"
    "testAugmOps"
    "testBinaryOps"
    "testUnaryOps"
  ];

  passthru = {
    # If using myhdl as a dependency, use these if needed and not ghdl and
    # verlog from all-packages.nix
    inherit ghdl iverilog;
  };

  meta = {
    description = "Free, open-source package for using Python as a hardware description and verification language";
    homepage = "https://www.myhdl.org/";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
