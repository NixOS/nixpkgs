{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder

# build time
, astropy-extension-helpers
, cython_3
, jinja2
, oldest-supported-numpy
, setuptools-scm
, wheel
# testing
, pytestCheckHook
, pytest-xdist
, pytest-astropy

# runtime
, astropy-iers-data
, numpy
, packaging
, pyerfa
, pyyaml
}:

buildPythonPackage rec {
  pname = "astropy";
  version = "6.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8"; # according to setup.cfg

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A82AGlUwXaUjzY14DXY1n1clXc3Fn+C91x/VFU/Hd9k=";
  };

  nativeBuildInputs = [
    astropy-extension-helpers
    cython_3
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
  pythonImportsCheck = [
    "astropy"
  ];
  disabledTests = [
    # May fail due to parallelism, see:
    # https://github.com/astropy/astropy/issues/15441
    "TestUnifiedOutputRegistry"
  ];

  meta = {
    description = "Astronomy/Astrophysics library for Python";
    homepage = "https://www.astropy.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kentjames doronbehar ];
  };
}
