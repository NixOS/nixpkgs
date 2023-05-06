{ lib
, buildPythonPackage
, fetchFromGitHub
, coreutils
, jinja2
, pandas
, pyparsing
, pytestCheckHook
, pythonOlder
, which
, yosys
}:

buildPythonPackage rec {
  pname = "edalize";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "olofk";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jsrJr/iuezh9/KL0PykWB1XKev4Wr5QeDh0ZWNMZSp8=";
  };

  postPatch = ''
    substituteInPlace tests/test_edam.py \
      --replace /usr/bin/touch ${coreutils}/bin/touch
    patchShebangs tests/mock_commands/vsim
  '';

  propagatedBuildInputs = [
    jinja2
  ];

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

  pythonImportsCheck = [
    "edalize"
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
    homepage = "https://github.com/olofk/edalize";
    changelog = "https://github.com/olofk/edalize/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ astro ];
  };
}
