{ lib
, fetchPypi
, python
, buildPythonPackage
, cython
, numpy
, petsc
, openmpi
, openssh
, mpi4py
, pytest }:

buildPythonPackage rec {
  pname = "petsc4py";
  version = "3.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "094hcnran0r2z1wlvmjswsz3ski1m9kqrl5l0ax8jjhnk55x0flh";
  };

  PETSC_DIR = "${petsc}";

  setupPyBuildFlags = [ "build_src --force" ];

  buildInputs = [
    cython
    numpy
    openssh
    mpi4py
  ];

  propagatedBuildInputs = [
    petsc
    openmpi
  ];

  checkInputs = [ pytest ];

  meta = {
    description = "Python bindings for PETSc, the Portable, Extensible Toolkit for Scientific Computation";
    homepage = https://bitbucket.org/petsc/petsc4py;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jamtrott ];
  };
}
