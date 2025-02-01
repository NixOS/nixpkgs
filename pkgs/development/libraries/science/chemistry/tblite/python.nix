{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchpatch,
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

  nativeBuildInputs =
    [
      tblite
      meson
      ninja
      pkg-config
      gfortran
      mctc-lib
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
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

    # Toml-f 0.4.0 compatibility https://github.com/tblite/tblite/pull/108
    (fetchpatch {
      url = "https://github.com/tblite/tblite/commit/e4255519b58a5198a5fa8f3073bef1c78a4bbdbe.diff";
      hash = "sha256-BMwYsdWfK+vG3BFgzusLYfwo0WXrYSPxJoEJIyOvbPg=";
    })
  ];

  format = "other";
  pythonImportsCheck = [
    "tblite"
    "tblite.interface"
  ];
  mesonFlags = [ "-Dpython=true" ];
}
