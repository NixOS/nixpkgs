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
  writableTmpDirAsHomeHook,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "atomman";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "atomman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9QDc4V1q179WupJEWYHyP8qs1afoB9OojjkGL1QlS5M=";
  };

  postPatch = ''
    # Upstream limits setuptools to top-level atomman only
    substituteInPlace pyproject.toml \
      --replace-fail "packages = ['atomman']" "packages = {find = {include = [\"atomman*\"]}}"
  '';

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
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # needs network access to download database files
    "test_unique_shifts_prototype"
  ];

  pythonImportsCheck = [ "atomman" ];

  meta = {
    description = "Atomistic Manipulation Toolkit";
    homepage = "https://github.com/usnistgov/atomman/";
    changelog = "https://github.com/usnistgov/atomman/blob/${finalAttrs.src.tag}/UPDATES.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
