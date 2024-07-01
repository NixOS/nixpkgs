{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  setuptools,
  configparser,
  pyparsing,
  pytestCheckHook,
  future,
  openpyxl,
  wrapt,
  scipy,
  cexprtk,
  deepdiff,
  sympy,
}:

buildPythonPackage rec {
  pname = "atsim-potentials";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mjdrushton";
    repo = "atsim-potentials";
    rev = "refs/tags/${version}";
    hash = "sha256-G7lNqwEUwAT0f7M2nUTCxpXOAl6FWKlh7tcsvbur1eM=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  # these files try to import `distutils` removed in Python 3.12
  disabledTestPaths = lib.optionals (pythonAtLeast "3.12") [
    "tests/config/test_configuration_eam.py"
    "tests/config/test_configuration_eam_fs.py"
    "tests/config/test_configuration_pair.py"
    "tests/test_dlpoly_writeTABEAM.py"
    "tests/test_documentation_examples.py"
    "tests/test_eam_adp_writer.py"
    "tests/test_gulp_writer.py"
    "tests/test_lammpsWriteEAM.py"
  ];

  disabledTests = [
    # Missing lammps executable
    "eam_tabulate_example2TestCase"
  ];

  pythonImportsCheck = [ "atsim.potentials" ];

  meta = with lib; {
    homepage = "https://github.com/mjdrushton/atsim-potentials";
    description = "Provides tools for working with pair and embedded atom method potential models including tabulation routines for DL_POLY and LAMMPS";
    mainProgram = "potable";
    license = licenses.mit;
    maintainers = [ ];
  };
}
