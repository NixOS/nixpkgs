{ stdenv, fetchPypi, isPy27, python, buildPythonPackage
, numpy, hdf5, cython, six, pkgconfig, unittest2, fetchpatch
, mpi4py ? null, openssh, pytest }:

assert hdf5.mpiSupport -> mpi4py != null && hdf5.mpi == mpi4py.mpi;

with stdenv.lib;

let
  mpi = hdf5.mpi;
  mpiSupport = hdf5.mpiSupport;
in buildPythonPackage rec {
  version = "2.10.0";
  pname = "h5py";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "84412798925dc870ffd7107f045d7659e60f5d46d1c70c700375248bf6bf512d";
  };

  configure_flags = "--hdf5=${hdf5}" + optionalString mpiSupport " --mpi";

  postConfigure = ''
    ${python.executable} setup.py configure ${configure_flags}

    # Needed to run the tests reliably. See:
    # https://bitbucket.org/mpi4py/mpi4py/issues/87/multiple-test-errors-with-openmpi-30
    ${optionalString mpiSupport "export OMPI_MCA_rmaps_base_oversubscribe=yes"}
  '';

  preBuild = if mpiSupport then "export CC=${mpi}/bin/mpicc" else "";

  checkInputs = optional isPy27 unittest2 ++ [ pytest openssh ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ hdf5 cython ]
    ++ optional mpiSupport mpi;
  propagatedBuildInputs = [ numpy six]
    ++ optionals mpiSupport [ mpi4py openssh ];

  meta = {
    description =
      "Pythonic interface to the HDF5 binary data format";
    homepage = "http://www.h5py.org/";
    license = stdenv.lib.licenses.bsd2;
  };
}
