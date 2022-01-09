{ lib
, fetchFromGitHub
, python
, cython
, buildPythonPackage
, mpi
, openssh }:

buildPythonPackage rec {
  pname = "mpi4py";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "mpi4py";
    repo = "mpi4py";
    rev = version;
    sha256 = "sha256-CUpRh63xmqRUveVGJoHVaOdrqDM3D+P14aV0IrwJIVw=";
  };

  passthru = {
    inherit mpi;
  };

  postPatch = ''
    substituteInPlace test/test_spawn.py --replace \
                      "unittest.skipMPI('openmpi(<3.0.0)')" \
                      "unittest.skipMPI('openmpi')"
    conf/cythonize.sh
  '';

  setupPyBuildFlags = ["--mpicc=${mpi}/bin/mpicc"];

  nativeBuildInputs = [ cython mpi openssh ];

  meta = with lib; {
    description = "Python bindings for the Message Passing Interface standard";
    homepage = "https://bitbucket.org/mpi4py/mpi4py/";
    license = licenses.bsd3;
  };
}
