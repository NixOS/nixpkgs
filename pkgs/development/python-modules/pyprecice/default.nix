{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  pip,
  pkgconfig,
  setuptools,

  # dependencies
  mpi4py,
  numpy,
  precice,
}:

buildPythonPackage rec {
  pname = "pyprecice";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "precice";
    repo = "python-bindings";
    tag = "v${version}";
    hash = "sha256-8AM2wbPX54UaMO4MzLOV0TljLTAPOqR9gUbtT2McNjs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=61,<72" "setuptools"
  '';

  build-system = [
    cython
    pip
    pkgconfig
    setuptools
  ];

  dependencies = [
    numpy
    mpi4py
    precice
  ];

  # Disable Test because everything depends on open mpi which requires network
  doCheck = false;

  # Do not use pythonImportsCheck because this will also initialize mpi which requires a network interface

  meta = {
    description = "Python language bindings for preCICE";
    homepage = "https://github.com/precice/python-bindings";
    changelog = "https://github.com/precice/python-bindings/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
}
