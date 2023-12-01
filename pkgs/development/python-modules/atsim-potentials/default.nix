{ lib
, buildPythonPackage
, fetchFromGitHub
, configparser
, pyparsing
, pytestCheckHook
, future
, openpyxl
, wrapt
, scipy
, cexprtk
, deepdiff
, sympy
}:

buildPythonPackage rec {
  version = "0.4.1";
  pname = "atsim-potentials";

  src = fetchFromGitHub {
    owner = "mjdrushton";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-G7lNqwEUwAT0f7M2nUTCxpXOAl6FWKlh7tcsvbur1eM=";
  };

  postPatch = ''
    # Remove conflicting openpyxl dependency version check
    sed -i '/openpyxl==2.6.4/d' setup.py
  '';

  propagatedBuildInputs = [
    cexprtk
    configparser
    future
    openpyxl
    pyparsing
    scipy
    sympy
    wrapt
  ];

  nativeCheckInputs = [
    deepdiff
    pytestCheckHook
  ];

  disabledTests = [
    # Missing lammps executable
    "eam_tabulate_example2TestCase"
    "test_pymath"
  ];

  pythonImportsCheck = [ "atsim.potentials" ];

  meta = with lib; {
    homepage = "https://github.com/mjdrushton/atsim-potentials";
    description = "Provides tools for working with pair and embedded atom method potential models including tabulation routines for DL_POLY and LAMMPS";
    license = licenses.mit;
    maintainers = [ ];
  };
}
