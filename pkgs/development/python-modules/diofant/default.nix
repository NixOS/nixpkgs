{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  fetchpatch,
  gmpy2,
  hypothesis,
  mpmath,
  numpy,
  pexpect,
  pythonOlder,
  pytest-cov-stub,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  scipy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "diofant";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "diofant";
    repo = "diofant";
    tag = "v${version}";
    hash = "sha256-uQvAYSURDhuAKcX0WVMk4y2ZXiiq0lPZct/7A5n5t34=";
  };

  patches = [
    (fetchpatch {
      name = "remove-pip-from-build-dependencies.patch";
      url = "https://github.com/diofant/diofant/commit/117e441808faa7c785ccb81bf211772d60ebdec3.patch";
      hash = "sha256-MYk1Ku4F3hAv7+jJQLWhXd8qyKRX+QYuBzPfYWT0VbU=";
    })
  ];

  build-system = [ setuptools-scm ];

  dependencies = [ mpmath ];

  optional-dependencies = {
    exports = [
      cython
      numpy
      scipy
    ];
    gmpy = [ gmpy2 ];
  };

  doCheck = false; # some tests get stuck easily

  nativeCheckInputs = [
    hypothesis
    pexpect
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTestMarks = [
    "slow"
  ];

  disabledTests = [
    # AssertionError: assert '9.9012134805...5147838841057' == '2.7182818284...2178525166427'
    "test_evalf_fast_series"
    # AssertionError: assert Float('0.0051000000000000004', dps=15) == Float('0.010050166663333571', dps=15)
    "test_evalf_sum"
  ];

  pythonImportsCheck = [ "diofant" ];

  meta = with lib; {
    changelog = "https://diofant.readthedocs.io/en/latest/release/notes-${src.tag}.html";
    description = "Python CAS library";
    homepage = "https://github.com/diofant/diofant";
    license = licenses.bsd3;
    maintainers = with maintainers; [ suhr ];
  };
}
