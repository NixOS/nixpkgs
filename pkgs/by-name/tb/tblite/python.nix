{
  lib,
  buildPythonPackage,
  meson-python,
  meson,
  ninja,
  pkg-config,
  gfortran,
  setuptools,
  cffi,
  numpy,
  tblite,
  blas,
  lapack,
  mctc-lib,
  mstore,
  toml-f,
  multicharge,
  dftd4,
  ddx,
  hdf5-fortran,
  trexio,
  simple-dftd3,
}:

buildPythonPackage {
  inherit (tblite)
    pname
    version
    src
    postPatch
    meta
    ;

  pyproject = true;

  sourceRoot = "source/python";

  dontUseMesonConfigure = true;

  nativeBuildInputs = [
    meson-python
    meson
    ninja
    pkg-config
    gfortran
    setuptools
  ];

  dependencies = [
    cffi
    numpy
  ];

  buildInputs = [
    tblite
    simple-dftd3
    blas
    lapack
    mctc-lib
    mstore
    toml-f
    multicharge
    dftd4
    ddx
    hdf5-fortran
    trexio
  ];

  pythonImportsCheck = [
    "tblite"
    "tblite.interface"
  ];
}
