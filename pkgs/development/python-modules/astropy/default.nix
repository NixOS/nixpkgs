{
  lib,
  fetchPypi,
  fetchpatch,
  buildPythonPackage,
  pythonOlder,

  # build time
  stdenv,
  cython,
  extension-helpers,
  setuptools,
  setuptools-scm,

  # dependencies
  astropy-iers-data,
  numpy,
  packaging,
  pyerfa,
  pyyaml,

  # optional-depedencies
  scipy,
  matplotlib,
  ipython,
  ipywidgets,
  ipykernel,
  pandas,
  certifi,
  dask,
  h5py,
  pyarrow,
  beautifulsoup4,
  html5lib,
  sortedcontainers,
  pytz,
  jplephem,
  mpmath,
  asdf,
  asdf-astropy,
  bottleneck,
  fsspec,
  s3fs,

  # testing
  pytestCheckHook,
  pytest-xdist,
  pytest-astropy-header,
  pytest-astropy,
  threadpoolctl,

}:

buildPythonPackage rec {
  pname = "astropy";
  version = "7.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6S18n+6G6z34cU5d1Bu/nxY9ND4aGD2Vv2vQnkMTyUA=";
  };
  patches = [
    (fetchpatch {
      url = "https://github.com/astropy/astropy/commit/13b89edc9acd6d5f12eea75983084c57cb458130.patch";
      hash = "sha256-2MgmW4kKBrZnTE1cjYYLOH5hStv5Q6tv4gN4sPSLBpM=";
    })
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=unused-command-line-argument";
  };

  build-system = [
    cython
    extension-helpers
    setuptools
    setuptools-scm
  ];

  dependencies = [
    astropy-iers-data
    numpy
    packaging
    pyerfa
    pyyaml
  ];

  optional-dependencies = lib.fix (self: {
    recommended = [
      scipy
      matplotlib
    ];
    ipython = [
      ipython
    ];
    jupyter = [
      ipywidgets
      ipykernel
      # ipydatagrid
      pandas
    ] ++ self.ipython;
    all =
      [
        certifi
        dask
        h5py
        pyarrow
        beautifulsoup4
        html5lib
        sortedcontainers
        pytz
        jplephem
        mpmath
        asdf
        asdf-astropy
        bottleneck
        fsspec
        s3fs
      ]
      ++ self.recommended
      ++ self.ipython
      ++ self.jupyter
      ++ dask.optional-dependencies.array
      ++ fsspec.optional-dependencies.http;
  });

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-astropy-header
    pytest-astropy
    threadpoolctl
  ] ++ optional-dependencies.recommended;

  pythonImportsCheck = [ "astropy" ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export HOME="$(mktemp -d)"
    export OMP_NUM_THREADS=$(( $NIX_BUILD_CORES / 4 ))
    # See https://github.com/astropy/astropy/issues/17649 and see
    # --hypothesis-profile=ci pytest flag below.
    cp conftest.py $out/
    # https://github.com/NixOS/nixpkgs/issues/255262
    cd "$out"
  '';
  pytestFlagsArray = [
    "--hypothesis-profile=ci"
  ];
  postCheck = ''
    rm conftest.py
  '';

  meta = {
    description = "Astronomy/Astrophysics library for Python";
    homepage = "https://www.astropy.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      kentjames
      doronbehar
    ];
  };
}
