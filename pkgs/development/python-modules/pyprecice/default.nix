{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  pkgconfig,
  setuptools,
  setuptools-git-versioning,

  # dependencies
  mpi4py,
  numpy,
  precice,
}:

buildPythonPackage rec {
  pname = "pyprecice";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "precice";
    repo = "python-bindings";
    tag = "v${version}";
    hash = "sha256-NkTrMZ7UKB5O2jIlhLhgkOm8ZeWJA1FoursA1df7XOk=";
  };

  build-system = [
    cython
    pkgconfig
    setuptools
    setuptools-git-versioning
  ];

  dependencies = [
    numpy
    mpi4py
  ];

  buildInputs = [
    precice
  ];

  # no official test instruction
  doCheck = false;

  pythonImportsCheck = [
    "precice"
  ];

  meta = {
    description = "Python language bindings for preCICE";
    homepage = "https://github.com/precice/python-bindings";
    changelog = "https://github.com/precice/python-bindings/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
}
