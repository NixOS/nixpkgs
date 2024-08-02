{
  lib,
  buildPythonPackage,
  setuptools,
  pip,
  cython,
  fetchFromGitHub,
  mpi4py,
  numpy,
  precice,
  pkgconfig,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyprecice";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "precice";
    repo = "python-bindings";
    rev = "refs/tags/v${version}";
    hash = "sha256-qeDWj03Uo0Kf75MN0eI+DBwa94v7GRe6+FKYtVOM6vs=";
  };

  nativeBuildInputs = [
    setuptools
    pip
    cython
    pkgconfig
  ];

  propagatedBuildInputs = [
    numpy
    mpi4py
    precice
  ];

  # Disable Test because everything depends on open mpi which requires network
  doCheck = false;

  # Do not use pythonImportsCheck because this will also initialize mpi which requires a network interface

  meta = with lib; {
    description = "Python language bindings for preCICE";
    homepage = "https://github.com/precice/python-bindings";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
