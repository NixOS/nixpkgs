{ lib
, fetchPypi
, fetchpatch
, buildPythonPackage
, pythonOlder

# build time
, astropy-extension-helpers
, cython
, jinja2
, oldest-supported-numpy
, setuptools-scm
, wheel
# testing
, pytestCheckHook
, pytest-xdist
, pytest-astropy
, python

# runtime
, numpy
, packaging
, pyerfa
, pyyaml
}:

buildPythonPackage rec {
  pname = "astropy";
  version = "5.3.4";
  format = "pyproject";

  disabled = pythonOlder "3.8"; # according to setup.cfg

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1JD34vqsLMwBySRCAtYpFUJZr4qXkQTO2J3ErOTm8dg=";
  };
  # Relax cython dependency to allow this to build, upstream only doesn't
  # support cython 3 as of writing. See:
  # https://github.com/astropy/astropy/issues/15315
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'cython==' 'cython>='
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
  pythonImportsCheck = [
    "astropy"
  ];
  disabledTests = [
    # May fail due to parallelism, see:
    # https://github.com/astropy/astropy/issues/15441
    "TestUnifiedOutputRegistry"
    "test_datetime_to_timedelta"
  ];

  meta = {
    description = "Astronomy/Astrophysics library for Python";
    homepage = "https://www.astropy.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kentjames doronbehar ];
  };
}
