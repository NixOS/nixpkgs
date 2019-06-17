{ lib
, fetchPypi
, python
, buildPythonPackage
, cython
, numpy
, openmpi
, openssh
, petsc
, pytest }:

buildPythonPackage rec {
  pname = "petsc4py";
  version = "3.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "094hcnran0r2z1wlvmjswsz3ski1m9kqrl5l0ax8jjhnk55x0flh";
  };

  PETSC_DIR = "${petsc}";

  # The "build_src --force" flag is used to re-build the package's cython code.
  # This prevents issues when using multiple cython-based packages
  # together (for example, mpi4py and petsc4py) due to code that has been
  # generated with incompatible cython versions.
  setupPyBuildFlags = [ "build_src --force" ];

  nativeBuildInputs = [ cython openmpi openssh ];
  propagatedBuildInputs = [ numpy ];
  checkInputs = [ pytest ];

  meta = {
    description = "Python bindings for PETSc, the Portable, Extensible Toolkit for Scientific Computation";
    homepage = https://bitbucket.org/petsc/petsc4py;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jamtrott ];
  };
}
