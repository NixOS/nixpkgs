{
  lib,
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
  pytestCheckHook,
  requests,
  scipy,
  setuptools,
  toolz,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "atomman";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "atomman";
    tag = "v${version}";
    hash = "sha256-UmvMYVM1YmLvSaVLzWHdxYpRU+Z3z65cy7mfmDZfDG0=";
  };

  build-system = [
    setuptools
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

  pythonRelaxDeps = [ "atomman" ];

  preCheck = ''
    # By default, pytestCheckHook imports atomman from the current directory
    # instead of from where `pip` installs it and fails due to missing Cython
    # modules. Fix this by removing atomman from the current directory.
    #
    rm -r atomman
  '';

  nativeCheckInputs = [
    phonopy
    pytestCheckHook
  ];

  disabledTests = [
    "test_unique_shifts_prototype" # needs network access to download database files
  ];

  pythonImportsCheck = [ "atomman" ];

  meta = {
    changelog = "https://github.com/usnistgov/atomman/blob/${src.rev}/UPDATES.rst";
    description = "Atomistic Manipulation Toolkit";
    homepage = "https://github.com/usnistgov/atomman/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
