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
  version = "5.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.8"; # according to setup.cfg

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AzDfn116IlQ2fpuM9EJVuhBwsGEjGIxqcu3BgEk/k7s=";
  };
  patches = [
    # Fixes running tests in parallel issue
    # https://github.com/astropy/astropy/issues/15316. Fix from
    # https://github.com/astropy/astropy/pull/15327
    (fetchpatch {
      url = "https://github.com/astropy/astropy/commit/1042c0fb06a992f683bdc1eea2beda0b846ed356.patch";
      hash = "sha256-bApAcGBRrJ94thhByoYvdqw2e6v77+FmTfgmGcE6MMk=";
    })
  ];

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

  meta = {
    description = "Astronomy/Astrophysics library for Python";
    homepage = "https://www.astropy.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kentjames doronbehar ];
  };
}
