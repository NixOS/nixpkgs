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
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "obspy";
    repo = "obspy";
    tag = version;
    hash = "sha256-QBV9FRvUUy8/5KK5RdAXXLB8SK9llFy1XRnQ9T5bgcU=";
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
    changelog = "https://github.com/obspy/obspy/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.ametrine ];
  };
}
