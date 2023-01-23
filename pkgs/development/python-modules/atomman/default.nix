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
, pytestCheckHook
, pythonOlder
, pythonAtLeast
, requests
, scipy
, setuptools
, toolz
, xmltodict
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  version = "1.4.6";
  pname = "atomman";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "atomman";
    rev = "v${version}";
    hash = "sha256-tcsxtFbBdMC6+ixzqhnR+5UNwcQmnPQSvuyNA2IYelI=";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

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

  pythonRelaxDeps = [ "potentials" ];

  preCheck = ''
    # By default, pytestCheckHook imports atomman from the current directory
    # instead of from where `pip` installs it and fails due to missing Cython
    # modules. Fix this by removing atomman from the current directory.
    #
    rm -r atomman
  '';

  nativeCheckInputs = [
    ase
    phonopy
    pymatgen
    pytest
    pytestCheckHook
  ];

  disabledTests = [
    "test_unique_shifts_prototype" # needs network access to download database files
  ];

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
