{ lib, fetchPypi, isPy27, buildPythonPackage, pythonOlder
, numpy, hdf5, cython, six, pkgconfig, unittest2
, mpi4py ? null, openssh, pytestCheckHook, cached-property }:

assert hdf5.mpiSupport -> mpi4py != null && hdf5.mpi == mpi4py.mpi;

let
  mpi = hdf5.mpi;
  mpiSupport = hdf5.mpiSupport;
in buildPythonPackage rec {
  version = "3.6.0";
  pname = "h5py";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8752d2814a92aba4e2b2a5922d2782d0029102d99caaf3c201a566bc0b40db29";
  };

  # avoid strict pinning of numpy
  postPatch = ''
    substituteInPlace setup.py \
      --replace "numpy ==" "numpy >=" \
      --replace "mpi4py ==" "mpi4py >="
  '';

  HDF5_DIR = "${hdf5}";
  HDF5_MPI = if mpiSupport then "ON" else "OFF";

  postConfigure = ''
    # Needed to run the tests reliably. See:
    # https://bitbucket.org/mpi4py/mpi4py/issues/87/multiple-test-errors-with-openmpi-30
    ${lib.optionalString mpiSupport "export OMPI_MCA_rmaps_base_oversubscribe=yes"}
  '';

  preBuild = if mpiSupport then "export CC=${mpi}/bin/mpicc" else "";

  # tests now require pytest-mpi, which isn't available and difficult to package
  doCheck = false;
  checkInputs = lib.optional isPy27 unittest2 ++ [ pytestCheckHook openssh ];
  nativeBuildInputs = [ pkgconfig cython ];
  buildInputs = [ hdf5 ]
    ++ lib.optional mpiSupport mpi;
  propagatedBuildInputs = [ numpy six]
    ++ lib.optionals mpiSupport [ mpi4py openssh ]
    ++ lib.optionals (pythonOlder "3.8") [ cached-property ];

  pythonImportsCheck = [ "h5py" ];

  meta = with lib; {
    description = "Pythonic interface to the HDF5 binary data format";
    homepage = "http://www.h5py.org/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
