{ stdenv, fetchPypi, isPy27, python, buildPythonPackage
, numpy, hdf5, cython, six, pkgconfig, unittest2, fetchpatch
, mpi4py ? null, openssh }:

assert hdf5.mpiSupport -> mpi4py != null && hdf5.mpi == mpi4py.mpi;

with stdenv.lib;

let
  mpi = hdf5.mpi;
  mpiSupport = hdf5.mpiSupport;
in buildPythonPackage rec {
  version = "2.9.0";
  pname = "h5py";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d41ca62daf36d6b6515ab8765e4c8c4388ee18e2a665701fef2b41563821002";
  };

  patches = [ ( fetchpatch {
    # Skip a test that probes an already fixed bug in HDF5 (upstream patch)
    url = "https://github.com/h5py/h5py/commit/141eafa531c6c09a06efe6a694251a1eea84908d.patch";
    sha256 = "0lmdn0gznr7gadx7qkxybl945fvwk6r0cc4lg3ylpf8ril1975h8";
  })];

  configure_flags = "--hdf5=${hdf5}" + optionalString mpiSupport " --mpi";

  postConfigure = ''
    ${python.executable} setup.py configure ${configure_flags}

    # Needed to run the tests reliably. See:
    # https://bitbucket.org/mpi4py/mpi4py/issues/87/multiple-test-errors-with-openmpi-30
    ${optionalString mpiSupport "export OMPI_MCA_rmaps_base_oversubscribe=yes"}
  '';

  preBuild = if mpiSupport then "export CC=${mpi}/bin/mpicc" else "";

  checkInputs = optional isPy27 unittest2 ++ [ openssh ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ hdf5 cython ]
    ++ optional mpiSupport mpi;
  propagatedBuildInputs = [ numpy six]
    ++ optionals mpiSupport [ mpi4py openssh ];

  meta = {
    description =
      "Pythonic interface to the HDF5 binary data format";
    homepage = http://www.h5py.org/;
    license = stdenv.lib.licenses.bsd2;
  };
}
