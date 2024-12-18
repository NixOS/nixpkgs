{
  lib,
  ase,
  buildPythonPackage,
  cython,
  datamodeldict,
  fetchFromGitHub,
  matplotlib,
  numericalunits,
  numpy,
  pandas,
  phonopy,
  potentials,
  pymatgen,
  pytestCheckHook,
  pythonOlder,
  requests,
  scipy,
  setuptools,
  toolz,
  wheel,
  xmltodict,
}:

buildPythonPackage {
  pname = "atomman";
  version = "1.4.6-unstable-2023-07-28";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "atomman";
    rev = "b8af21a9285959d38ee26173081db1b4488401bc";
    hash = "sha256-WfB+OY61IPprT6OCVHl8VA60p7lLVkRGuyYX+nm7bbA=";
  };


  build-system = [
    setuptools
    wheel
    numpy
    cython
  ];

  dependencies = [
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
    pytestCheckHook
  ];

  disabledTests = [
    "test_unique_shifts_prototype" # needs network access to download database files
  ];

  pythonImportsCheck = [ "atomman" ];

  meta = with lib; {
    description = "Atomistic Manipulation Toolkit";
    homepage = "https://github.com/usnistgov/atomman/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
