{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,

  # dependencies
  datamodeldict,
  matplotlib,
  numericalunits,
  pandas,
  potentials,
  requests,
  scipy,
  toolz,
  xmltodict,

  # tests
  phonopy,
  pytestCheckHook,

}:

buildPythonPackage (finalAttrs: {
  pname = "atomman";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "atomman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UmvMYVM1YmLvSaVLzWHdxYpRU+Z3z65cy7mfmDZfDG0=";
  };

  build-system = [
    cython
    numpy
    setuptools
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
    # needs network access to download database files
    "test_unique_shifts_prototype"
  ];

  pythonImportsCheck = [ "atomman" ];

  meta = {
    changelog = "https://github.com/usnistgov/atomman/blob/${finalAttrs.src.tag}/UPDATES.rst";
    description = "Atomistic Manipulation Toolkit";
    homepage = "https://github.com/usnistgov/atomman/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
