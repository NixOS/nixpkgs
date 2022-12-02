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
  version = "0.4.0";
  pname = "atsim-potentials";

  src = fetchFromGitHub {
    owner = "mjdrushton";
    repo = pname;
    rev = version;
    sha256 = "sha256-MwjRVd54qa8uJOi9yRXU+Vrve50ndftJUl+TFZKVzQM=";
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

  checkInputs = [
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
    maintainers = [ maintainers.costrouc ];
  };
}
