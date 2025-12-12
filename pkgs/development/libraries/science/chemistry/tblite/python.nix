{
  buildPythonPackage,
  meson,
  ninja,
  pkg-config,
  tblite,
  numpy,
  simple-dftd3,
  cffi,
  gfortran,
  blas,
  lapack,
  mctc-lib,
  mstore,
  toml-f,
  multicharge,
  dftd4,
  setuptools,
}:

buildPythonPackage {
  inherit (tblite)
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    tblite
    meson
    ninja
    pkg-config
    gfortran
    mctc-lib
    setuptools
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
  ];

  propagatedBuildInputs = [
    tblite
    simple-dftd3
    cffi
    numpy
  ];

  patches = [
    # Add multicharge to the meson deps; otherwise we get missing mod_multicharge errors
    ./0001-fix-multicharge-dep-needed-for-static-compilation.patch
  ];

  format = "other";
  pythonImportsCheck = [
    "tblite"
    "tblite.interface"
  ];
  mesonFlags = [ "-Dpython=true" ];
}
