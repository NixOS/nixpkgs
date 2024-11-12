{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  numpy,
  hdf5,
  cython,
  pkgconfig,
  mpi4py ? null,
  openssh,
  pytestCheckHook,
  pytest-mpi,
  cached-property,
}:

assert hdf5.mpiSupport -> mpi4py != null && hdf5.mpi == mpi4py.mpi;

let
  mpi = hdf5.mpi;
  mpiSupport = hdf5.mpiSupport;
in
buildPythonPackage rec {
  version = "3.12.1";
  pname = "h5py";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mm1wtT0xuqYfALiqX5XC/LliGj7oNl13DFUaE9u8v98=";
  };

  pythonRelaxDeps = [ "mpi4py" ];

  # avoid strict pinning of numpy and mpi4py, can't be replaced with
  # pythonRelaxDepsHook, see: https://github.com/NixOS/nixpkgs/issues/327941
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy >=2.0.0, <3" "numpy"
    substituteInPlace setup.py \
      --replace-fail "mpi4py ==3.1.6" "mpi4py"
  '';

  env = {
    HDF5_DIR = "${hdf5}";
    HDF5_MPI = if mpiSupport then "ON" else "OFF";
  };

  postConfigure = ''
    # Needed to run the tests reliably. See:
    # https://bitbucket.org/mpi4py/mpi4py/issues/87/multiple-test-errors-with-openmpi-30
    ${lib.optionalString mpiSupport "export OMPI_MCA_rmaps_base_oversubscribe=yes"}
  '';

  preBuild = lib.optionalString mpiSupport "export CC=${lib.getDev mpi}/bin/mpicc";

  build-system = [
    cython
    numpy
    pkgconfig
    setuptools
  ];

  buildInputs = [ hdf5 ] ++ lib.optional mpiSupport mpi;

  dependencies =
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
  };
}
