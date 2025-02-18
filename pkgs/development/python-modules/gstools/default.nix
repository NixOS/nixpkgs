{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  extension-helpers,
  numpy,
  setuptools,
  setuptools-scm,

  # dependencies
  hankel,
  emcee,
  meshio,
  pyevtk,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gstools";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GeoStat-Framework";
    repo = "GSTools";
    tag = "v${version}";
    hash = "sha256-Aieuk0Xjlut8rTZoFHcBpPtyIj/fstMrHiiKyDOpQlg=";
  };

  build-system = [
    cython
    extension-helpers
    numpy
    setuptools
    setuptools-scm
  ];

  dependencies = [
    emcee
    hankel
    meshio
    numpy
    pyevtk
    scipy
  ];

  pythonImportsCheck = [ "gstools" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Geostatistical toolbox";
    homepage = "https://github.com/GeoStat-Framework/GSTools";
    changelog = "https://github.com/GeoStat-Framework/GSTools/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
