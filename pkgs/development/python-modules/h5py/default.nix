{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  wheel,
  numpy,
  hdf5,
  cython_0,
  pkgconfig,
  mpi4py ? null,
  openssh,
  pytestCheckHook,
  cached-property,
}:

assert hdf5.mpiSupport -> mpi4py != null && hdf5.mpi == mpi4py.mpi;

let
  mpi = hdf5.mpi;
  mpiSupport = hdf5.mpiSupport;
in
buildPythonPackage rec {
  version = "3.11.0";
  pname = "h5py";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e36PeAcqLt7IfJg28l80ID/UkqRHVwmhi0F6M8+yH6k=";
  };

  patches = [
    # Unlock an overly strict locking of mpi4py version (seems not to be necessary).
    # See also: https://github.com/h5py/h5py/pull/2418/files#r1589372479
    ./mpi4py-requirement.patch
  ];

  # avoid strict pinning of numpy
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy >=2.0.0rc1" "numpy"
  '';

  HDF5_DIR = "${hdf5}";
  HDF5_MPI = if mpiSupport then "ON" else "OFF";

  postConfigure = ''
    # Needed to run the tests reliably. See:
    # https://bitbucket.org/mpi4py/mpi4py/issues/87/multiple-test-errors-with-openmpi-30
    ${lib.optionalString mpiSupport "export OMPI_MCA_rmaps_base_oversubscribe=yes"}
  '';

  preBuild = lib.optionalString mpiSupport "export CC=${lib.getDev mpi}/bin/mpicc";

  nativeBuildInputs = [
    cython_0
    numpy
    pkgconfig
    setuptools
    wheel
  ];

  buildInputs = [ hdf5 ] ++ lib.optional mpiSupport mpi;

  propagatedBuildInputs =
    [ numpy ]
    ++ lib.optionals mpiSupport [
      mpi4py
      openssh
    ]
    ++ lib.optionals (pythonOlder "3.8") [ cached-property ];

  # tests now require pytest-mpi, which isn't available and difficult to package
  doCheck = false;
  nativeCheckInputs = [
    pytestCheckHook
    openssh
  ];

  pythonImportsCheck = [ "h5py" ];

  meta = with lib; {
    changelog = "https://github.com/h5py/h5py/blob/${version}/docs/whatsnew/${lib.versions.majorMinor version}.rst";
    description = "Pythonic interface to the HDF5 binary data format";
    homepage = "http://www.h5py.org/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
