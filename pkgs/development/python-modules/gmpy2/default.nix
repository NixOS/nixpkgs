{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  isPyPy,
  setuptools,
  gmp,
  mpfr,
  libmpc,
  pytestCheckHook,
  hypothesis,
  cython,
  mpmath,
  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "gmpy2";
  version = "2.2.1";
  pyproject = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "aleaxit";
    repo = "gmpy";
    tag = "v${version}";
    hash = "sha256-wrMN3kqLnjItoybKYeo4Pp2M0uma7Kg0JEQM8lr6OI0=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-to_bytes-tests.patch";
      url = "https://github.com/aleaxit/gmpy/commit/1903841667e7a6842bdead90bd7798b99de5b7be.patch?full_index=1";
      hash = "sha256-rlssUIkQ1RCRSu5eCXKJ2lNa/oIoLzf9sxJuNfDrVmk=";
    })
  ];

  build-system = [ setuptools ];

  buildInputs = [
    gmp
    mpfr
    libmpc
  ];

  # make relative imports in tests work properly
  preCheck = ''
    rm gmpy2 -r
  '';

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    cython
    mpmath
  ];

  pythonImportsCheck = [ "gmpy2" ];

  passthru.tests = {
    inherit sage;
  };

  meta = {
    changelog = "https://github.com/aleaxit/gmpy/blob/${src.rev}/docs/history.rst";
    description = "Interface to GMP, MPFR, and MPC for Python 3.7+";
    homepage = "https://github.com/aleaxit/gmpy/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
