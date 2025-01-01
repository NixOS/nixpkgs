{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,

  # build time
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
  stdenv,
  pytest-xdist,
  pytest-astropy-header,
  pytest-astropy,
  threadpoolctl,

}:

buildPythonPackage rec {
  pname = "astropy";
  version = "7.0.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6S18n+6G6z34cU5d1Bu/nxY9ND4aGD2Vv2vQnkMTyUA=";
  };

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

  # Not running it inside the build directory. See:
  # https://github.com/astropy/astropy/issues/15316#issuecomment-1722190547
  preCheck = ''
    cd "$out"
    export HOME="$(mktemp -d)"
    export OMP_NUM_THREADS=$(( $NIX_BUILD_CORES / 4 ))
  '';

  disabledTests = [
    # tests for all availability of all optional deps
    "test_basic_testing_completeness"
    "test_all_included"

    # May fail due to parallelism, see:
    # https://github.com/astropy/astropy/issues/15441
    "TestUnifiedOutputRegistry"

    # flaky
    "test_timedelta_conversion"
    # More flaky tests, see: https://github.com/NixOS/nixpkgs/issues/294392
    "test_sidereal_lon_independent"
    "test_timedelta_full_precision_arithmetic"
    "test_datetime_to_timedelta"

    "test_datetime_difference_agrees_with_timedelta_no_hypothesis"

    # SAMPProxyError 1: 'Timeout expired!'
    "TestStandardProfile.test_main"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_sidereal_lat_independent" ];

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
