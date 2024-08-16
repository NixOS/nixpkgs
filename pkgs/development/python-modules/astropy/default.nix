{
  lib,
  fetchPypi,
  fetchpatch,
  buildPythonPackage,
  pythonOlder,

  # build time
  astropy-extension-helpers,
  cython,
  jinja2,
  oldest-supported-numpy,
  setuptools-scm,
  wheel,
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
  version = "6.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8"; # according to setup.cfg

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5cb0XZEcMKy41VbH+O2ZSuxxsQjmHu5QZ/AK8eTjYTg=";
  };

  patches = [
    (fetchpatch {
      name = "drop-usage-known-bad-actor-cdn.patch";
      url = "https://github.com/astropy/astropy/commit/d329cb38e49584ad0ff5244fd2fff74cfa1f92f1.patch";
      hash = "sha256-+DbDwYeyR+mMDLRB4jiyol/5WO0LwqSCCEwjgflxoTk=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2.0.0"  "numpy"
  '';

  nativeBuildInputs = [
    astropy-extension-helpers
    cython
    jinja2
    oldest-supported-numpy
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
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

    # fail due to pytest>=8
    # https://github.com/astropy/astropy/issues/15960#issuecomment-1913654471
    "test_distortion_header"

    # flaky
    "test_timedelta_conversion"
    # More flaky tests, see: https://github.com/NixOS/nixpkgs/issues/294392
    "test_sidereal_lon_independent"
    "test_timedelta_full_precision_arithmetic"
    "test_datetime_to_timedelta"

    "test_datetime_difference_agrees_with_timedelta_no_hypothesis"
  ] ++ lib.optionals stdenv.isDarwin [ "test_sidereal_lat_independent" ];

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
