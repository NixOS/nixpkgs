{ lib, buildPythonPackage, fetchFromGitHub, precice, numpy, mpi4py, cython }:

buildPythonPackage rec {
  pname = "pyprecice";
  version = "2.4.0.0";

  src = fetchFromGitHub {
    owner = "precice";
    repo = "python-bindings";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Endy5oiC1OWdtZlVPUkIdkzoDTc1b5TaQ6VEUWq5iSg=";
  };

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ numpy mpi4py precice ];

  doCheck = false; # Disable Test because everything depends on open mpi which requires network.
  # Do not use pythonImportsCheck because this will also initialize mpi which requires a network interface

  meta = with lib; {
    description = "Python language bindings for preCICE";
    homepage = "https://github.com/precice/python-bindings";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
