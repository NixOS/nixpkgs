{ lib
, ase
, buildPythonPackage
, cython
, datamodeldict
, fetchFromGitHub
, matplotlib
, numericalunits
, numpy
, pandas
, phonopy
, potentials
, pymatgen
, pytest
, pythonOlder
, pythonAtLeast
, requests
, scipy
, toolz
, xmltodict
}:

buildPythonPackage rec {
  version = "1.4.4";
  pname = "atomman";
  format = "setuptools";

  disabled = pythonOlder "3.6" || pythonAtLeast "3.10";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "atomman";
    rev = "v${version}";
    hash = "sha256-iLAB0KMtrTCyGpx+81QfHDPVDhq8OA6CDL/ipVRpyo0=";
  };

  propagatedBuildInputs = [
    cython
    datamodeldict
    matplotlib
    numericalunits
    numpy
    pandas
    potentials
    requests
    scipy
    toolz
    xmltodict
  ];

  checkInputs = [
    ase
    phonopy
    pymatgen
    pytest
  ];

  checkPhase = ''
    # pytestCheckHook doesn't work
    pytest tests -k "not test_rootdir and not test_version \
      and not test_atomic_mass and not imageflags \
      and not test_build_unit and not test_set_and_get_in_units \
      and not test_set_literal and not test_scalar_model " \
      --ignore tests/plot/test_interpolate.py \
      --ignore tests/tools/test_vect_angle.py
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
