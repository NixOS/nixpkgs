{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, mpi4py
, numpy
, precice
, pkgconfig
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyprecice";
  version = "3.0.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "precice";
    repo = "python-bindings";
    rev = "refs/tags/v${version}";
    hash = "sha256-iW3Mll28Z3Ew+eIJxeF1HR7JhVhXs9FiYaAb5TwYSpg=";
  };

  nativeBuildInputs = [
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
