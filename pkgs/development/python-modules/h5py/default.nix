{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  numpy,
  hdf5,
  pythonRelaxDepsHook,
  cython_0,
  pkgconfig,
  mpi4py ? null,
  openssh,
  pytestCheckHook,
  pytest-mpi,
  cached-property,
  stdenv,
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

  # avoid strict pinning of numpy, can't be replaced with pythonRelaxDepsHook,
  # see: https://github.com/NixOS/nixpkgs/issues/327941
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy >=2.0.0rc1" "numpy"
  '';
  pythonRelaxDeps = [ "mpi4py" ];

  HDF5_DIR = "${hdf5}";
  HDF5_MPI = if mpiSupport then "ON" else "OFF";

  postConfigure = ''
    # Needed to run the tests reliably. See:
    # https://bitbucket.org/mpi4py/mpi4py/issues/87/multiple-test-errors-with-openmpi-30
    ${lib.optionalString mpiSupport "export OMPI_MCA_rmaps_base_oversubscribe=yes"}
  '';

  preBuild = lib.optionalString mpiSupport "export CC=${lib.getDev mpi}/bin/mpicc";

  nativeBuildInputs = [
    pythonRelaxDepsHook
    cython_0
    pkgconfig
    setuptools
  ];

  buildInputs = [ hdf5 ] ++ lib.optional mpiSupport mpi;

  propagatedBuildInputs =
    [ numpy ]
    ++ lib.optionals mpiSupport [
      mpi4py
      openssh
    ]
    ++ lib.optionals (pythonOlder "3.8") [ cached-property ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpi
    openssh
  ];
  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';
  # For some reason these fail when mpi support is enabled, due to concurrent
  # writings. There are a few open issues about this in the bug tracker, but
  # not related to the tests.
  disabledTests = lib.optionals mpiSupport [ "TestPageBuffering" ];

  pythonImportsCheck = [ "h5py" ];

  meta = {
    changelog = "https://github.com/h5py/h5py/blob/${version}/docs/whatsnew/${lib.versions.majorMinor version}.rst";
    description = "Pythonic interface to the HDF5 binary data format";
    homepage = "http://www.h5py.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
    # When importing `h5py` during the build, we get:
    #
    # ValueError: Not a datatype (not a datatype)
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
