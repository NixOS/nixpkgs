{ lib
, buildPythonPackage
, cython
, datamodeldict
, fetchFromGitHub
, matplotlib
, numericalunits
, numpy
, pandas
, potentials
, pytest
, pythonOlder
, scipy
, toolz
, xmltodict
, python
}:

buildPythonPackage rec {
  version = "1.4.3";
  pname = "atomman";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "atomman";
    rev = "v${version}";
    sha256 = "sha256-is47O59Pjrh9tPC1Y2+DVVcHbxmcjUOFOVGnNHuURoM=";
  };

  propagatedBuildInputs = [
    cython
    datamodeldict
    matplotlib
    numericalunits
    numpy
    pandas
    potentials
    scipy
    toolz
    xmltodict
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    # pytestCheckHook doesn't work
    py.test tests -k "not test_rootdir and not test_version \
      and not test_atomic_mass and not imageflags"
  '';

  pythonImportsCheck = [
    "atomman"
  ];

  meta = with lib; {
    description = "Atomistic Manipulation Toolkit";
    homepage = "https://github.com/usnistgov/atomman/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
