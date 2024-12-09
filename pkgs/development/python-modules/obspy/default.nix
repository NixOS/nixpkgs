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

buildPythonPackage rec {
  pname = "obspy";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "obspy";
    repo = "obspy";
    rev = "refs/tags/${version}";
    hash = "sha256-Y833OWWBDYduyky0+MRbPoBtATTytak87hgh68QAgfw=";
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
    changelog = "https://github.com/obspy/obspy/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.ametrine ];
  };
}
