{ buildPythonPackage
, fetchPypi
, lib

, verilog
, verilator
, gnumake
, gcc

, edalize
, pyparsing
, pyyaml
, simplesat
, ipyxact

, setuptools-scm
}:
buildPythonPackage rec {
  pname = "fusesoc";
  version = "1.12.0";

  propagatedBuildInputs = [ edalize pyparsing pyyaml simplesat ipyxact verilog verilator gnumake gcc ];
  nativeBuildInputs = [ setuptools-scm ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hHDBQmCxcdwEtbisqOSB78fE3TkLv4opcdTDMHlWxYA=";
  };

  meta = with lib; {
    homepage = "https://github.com/olofk/fusesoc";
    description = "A package manager and build tools for HDL code";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}


