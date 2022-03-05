{ lib, buildPythonPackage, fetchFromGitHub, precice, numpy, mpi4py, cython }:

buildPythonPackage rec {
  pname = "pyprecice";
  version = "2.3.0.1";

  src = fetchFromGitHub {
    owner = "precice";
    repo = "python-bindings";
    rev = "v${version}";
    sha256 = "1yz96pif63ms797bzxbfrjba4mgz7cz5dqrqghn5sg0g1b9qxnn5";
  };

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ numpy mpi4py precice ];

  doCheck = false; # Disable Test because everything depends on open mpi which requires network.
  pythonImportChecks = [ "precice" ];

  meta = with lib; {
    description = "Python language bindings for preCICE";
    homepage = "https://github.com/precice/python-bindings";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
