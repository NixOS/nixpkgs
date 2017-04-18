{ stdenv, fetchurl, python, buildPythonPackage,
  cython, mpi, openssh }:

buildPythonPackage rec {
  name = "mpi4py-2.0.0";

  src = fetchurl {
    url = "https://bitbucket.org/mpi4py/mpi4py/downloads/${name}.tar.gz";
    sha256 = "10fb01595rg17ycz08a23v24akm25d13srsy2rnixam7a5ca0hv5";
  };

  passthru = {
    inherit mpi;
  };

  # mpi4py 2.0.0 patch NOT needed in future releases
  # https://bitbucket.org/mpi4py/mpi4py/issues/28/test_dltestdl-test-failure
  patches = [ ./test-libm.patch ];

  preBuild = "export MPICC=${mpi}/bin/mpicc";

  buildInputs = [ mpi cython ];
  # Requires openssh for tests. Tests of dependent packages will also fail,
  # if openssh is not present. E.g. h5py with mpi support.
  propagatedBuildInputs = [ openssh ];

  meta = {
    description =
      "Python bindings for the Message Passing Interface standard";
    homepage = "https://bitbucket.org/mpi4py/mpi4py";
    license = stdenv.lib.licenses.bsd3;
  };
}
