{ stdenv, fetchPypi, isPy27, python, buildPythonPackage, pythonOlder
, numpy, hdf5, cython, six, pkgconfig, unittest2, fetchpatch
, mpi4py ? null, openssh, pytestCheckHook, cached-property }:

assert hdf5.mpiSupport -> mpi4py != null && hdf5.mpi == mpi4py.mpi;

with stdenv.lib;

let
  mpi = hdf5.mpi;
  mpiSupport = hdf5.mpiSupport;
in buildPythonPackage rec {
  version = "3.1.0";
  pname = "h5py";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e2516f190652beedcb8c7acfa1c6fa92d99b42331cbef5e5c7ec2d65b0fc3c2";
  };

  # avoid strict pinning of numpy
  postPatch = ''
    substituteInPlace setup.py \
      --replace "numpy ==" "numpy >="
  '';

  HDF5_DIR = "${hdf5}";
  HDF5_MPI = if mpiSupport then "ON" else "OFF";

  postConfigure = ''
    # Needed to run the tests reliably. See:
    # https://bitbucket.org/mpi4py/mpi4py/issues/87/multiple-test-errors-with-openmpi-30
    ${optionalString mpiSupport "export OMPI_MCA_rmaps_base_oversubscribe=yes"}
  '';

  preBuild = if mpiSupport then "export CC=${mpi}/bin/mpicc" else "";

  # tests now require pytest-mpi, which isn't available and difficult to package
  doCheck = false;
  checkInputs = optional isPy27 unittest2 ++ [ pytestCheckHook openssh ];
  nativeBuildInputs = [ pkgconfig cython ];
  buildInputs = [ hdf5 ]
    ++ optional mpiSupport mpi;
  propagatedBuildInputs = [ numpy six]
    ++ optionals mpiSupport [ mpi4py openssh ]
    ++ optionals (pythonOlder "3.8") [ cached-property ];

  pythonImportsCheck = [ "h5py" ];

  meta = {
    description =
      "Pythonic interface to the HDF5 binary data format";
    homepage = "http://www.h5py.org/";
    license = stdenv.lib.licenses.bsd2;
  };
}
