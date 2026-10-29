{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  decorator,
  lxml,
  matplotlib,
  numpy,
  requests,
  scipy,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "obspy";
  version = "1.4.2-unstable-2025-08-21";
  pyproject = true;

  # Applies a gcc fix that can't be applied as a patch due to other repo changes
  src = fetchFromGitHub {
    owner = "obspy";
    repo = "obspy";
    rev = "75bac0c96aa04a0e233e72a7c89ebe97a3b48954";
    hash = "sha256-B55tVae8NRZZclekTvnxiFUk/bVijk7GpaccPFh15Xc=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "sqlalchemy" ];

  dependencies = [
    decorator
    lxml
    matplotlib
    numpy
    requests
    scipy
    sqlalchemy
  ];

  # Tests require Internet access.
  doCheck = false;

  pythonImportsCheck = [ "obspy" ];

  meta = {
    description = "Python framework for seismological observatories";
    homepage = "https://www.obspy.org";
    changelog = "https://github.com/obspy/obspy/releases/tag/v1.4.2";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.ametrine ];
  };
})
