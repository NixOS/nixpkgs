{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gmpy2,
  isPyPy,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest-xdist,
  hypothesis,
  pexpect,
  # Reverse dependency
  sage,
}:

buildPythonPackage (finalAttrs: {
  pname = "mpmath";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mpmath";
    repo = "mpmath";
    tag = finalAttrs.version;
    hash = "sha256-ykfKrpDri+4n9Y26S7nFl6nF0CV6V0A11ijmt8/apvg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies = {
    gmpy = lib.optionals (!isPyPy) [ gmpy2 ];
  };

  passthru.tests = {
    inherit sage;
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    hypothesis
    pexpect
  ];

  meta = {
    homepage = "https://mpmath.org/";
    description = "Pure-Python library for multiprecision floating arithmetic";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
