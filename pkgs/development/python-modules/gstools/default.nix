{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
  cython,
  extension-helpers,
  hankel,
  emcee,
  meshio,
  pyevtk,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gstools";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GeoStat-Framework";
    repo = "GSTools";
    rev = "refs/tags/v${version}";
    hash = "sha256-QpdOARzcSRVFl/DbnE2JLBFZmTSh/fBOmzweuf+zfEs=";
  };

  build-system = [
    setuptools
    setuptools-scm
    numpy
    cython
    extension-helpers
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
    changelog = "https://github.com/GeoStat-Framework/GSTools/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
