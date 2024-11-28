{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,

  # build time
  astropy-extension-helpers,
  cython,
  setuptools,
  setuptools-scm,

  # testing
  pytestCheckHook,
  stdenv,
  pytest-xdist,
  pytest-astropy,

  # runtime
  astropy-iers-data,
  numpy,
  packaging,
  pyerfa,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "astropy";
  version = "6.1.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NhVY4rCTqZvr5p8f1H+shqGSYHpMFu05ugqACyq2DDQ=";
  };

  build-system = [
    astropy-extension-helpers
    cython
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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-astropy
  ];

  # Not running it inside the build directory. See:
  # https://github.com/astropy/astropy/issues/15316#issuecomment-1722190547
  preCheck = ''
    cd "$out"
    export HOME="$(mktemp -d)"
    export OMP_NUM_THREADS=$(( $NIX_BUILD_CORES / 4 ))
  '';
  pythonImportsCheck = [ "astropy" ];
  disabledTests = [
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
