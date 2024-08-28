{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  coreutils,
  jinja2,
  pandas,
  pyparsing,
  pytestCheckHook,
  pythonOlder,
  which,
  yosys,
}:

buildPythonPackage rec {
  pname = "edalize";
  version = "0.5.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "olofk";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-pgyUpbSVRCHioJc82hZwG+JbpnL7t9ZvN4OcPHFsirs=";
  };

  postPatch = ''
    substituteInPlace tests/test_edam.py \
      --replace /usr/bin/touch ${coreutils}/bin/touch
    patchShebangs tests/mock_commands/vsim
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ jinja2 ];

  passthru.optional-dependencies = {
    reporting = [
      pandas
      pyparsing
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    which
    yosys
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "edalize" ];

  disabledTests = [
    # disable failures related to pandas 2.1.0 apply(...,errors="ignore")
    # behavior change. upstream pins pandas to 2.0.3 as of 2023-10-10
    # https://github.com/olofk/edalize/commit/2a3db6658752f97c61048664b478ebfe65a909f8
    "test_picorv32_artix7_summary"
    "test_picorv32_artix7_resources"
    "test_picorv32_artix7_timing"
    "test_picorv32_kusp_summary"
    "test_picorv32_kusp_resources"
    "test_picorv32_kusp_timing"
    "test_linux_on_litex_vexriscv_arty_a7_summary"
    "test_linux_on_litex_vexriscv_arty_a7_resources"
    "test_linux_on_litex_vexriscv_arty_a7_timing"
  ];

  disabledTestPaths = [
    "tests/test_questa_formal.py"
    "tests/test_slang.py"
    "tests/test_apicula.py"
    "tests/test_ascentlint.py"
    "tests/test_diamond.py"
    "tests/test_gatemate.py"
    "tests/test_ghdl.py"
    "tests/test_icarus.py"
    "tests/test_icestorm.py"
    "tests/test_ise.py"
    "tests/test_mistral.py"
    "tests/test_openlane.py"
    "tests/test_oxide.py"
    "tests/test_quartus.py"
    "tests/test_radiant.py"
    "tests/test_spyglass.py"
    "tests/test_symbiyosys.py"
    "tests/test_trellis.py"
    "tests/test_vcs.py"
    "tests/test_veribleformat.py"
    "tests/test_veriblelint.py"
    "tests/test_vivado.py"
    "tests/test_xcelium.py"
    "tests/test_xsim.py"
  ];

  meta = with lib; {
    description = "Abstraction library for interfacing EDA tools";
    mainProgram = "el_docker";
    homepage = "https://github.com/olofk/edalize";
    changelog = "https://github.com/olofk/edalize/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ astro ];
  };
}
