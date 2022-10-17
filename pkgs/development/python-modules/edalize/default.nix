{ lib
, buildPythonPackage
, fetchFromGitHub
, coreutils
, jinja2
, pandas
, pytestCheckHook
, which
, verilog
, yosys
}:

buildPythonPackage rec {
  pname = "edalize";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "olofk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fpUNCxW7+uymodJ/yGME9VNcCEZdBROIdT1+blpgkzA=";
  };

  postPatch = ''
    substituteInPlace tests/test_edam.py \
      --replace /usr/bin/touch ${coreutils}/bin/touch
    patchShebangs tests/mock_commands/vsim
  '';

  propagatedBuildInputs = [ jinja2 ];

  checkInputs = [
    pytestCheckHook
    pandas
    which
    yosys
    verilog
  ];

  pythonImportsCheck = [ "edalize" ];

  disabledTestPaths = [
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
    license = licenses.bsd2;
    maintainers = [ maintainers.astro ];
  };
}
