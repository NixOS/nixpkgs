{ stdenv, fetchPypi, isPy27, python, buildPythonPackage
, numpy, hdf5, cython, six, pkgconfig, unittest2
, mpi4py ? null, openssh }:

assert hdf5.mpiSupport -> mpi4py != null && hdf5.mpi == mpi4py.mpi;

with stdenv.lib;

let
  mpi = hdf5.mpi;
  mpiSupport = hdf5.mpiSupport;
in buildPythonPackage rec {
  version = "2.8.0";
  pname = "h5py";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mdr6wrq02ac93m1aqx9kad0ppfzmm4imlxqgyy1x4l7hmdcc9p6";
  };

  configure_flags = "--hdf5=${hdf5}" + optionalString mpiSupport " --mpi";

  postConfigure = ''
    ${python.executable} setup.py configure ${configure_flags}

    # Needed to run the tests reliably. See:
    # https://bitbucket.org/mpi4py/mpi4py/issues/87/multiple-test-errors-with-openmpi-30
    ${optionalString mpiSupport "export OMPI_MCA_rmaps_base_oversubscribe=yes"}
  '';

  preBuild = if mpiSupport then "export CC=${mpi}/bin/mpicc" else "";

  checkInputs = optional isPy27 unittest2;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ hdf5 cython ]
    ++ optional mpiSupport mpi;
  propagatedBuildInputs = [ numpy six]
    ++ optionals mpiSupport [ mpi4py openssh ];

  # https://github.com/h5py/h5py/issues/1088
  doCheck = false;

  meta = {
    description =
      "Pythonic interface to the HDF5 binary data format";
    homepage = http://www.h5py.org/;
    license = stdenv.lib.licenses.bsd2;
  };
}
