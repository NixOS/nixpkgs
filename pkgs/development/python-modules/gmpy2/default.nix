{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
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

  disabledTests =
    lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # issue with some overflow logic
      "test_mpz_to_bytes"
      "test_mpz_from_bytes"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # TypeError: mpq() requires numeric or string argument
      # not sure why it only fails on Darwin
      "test_mpq_from_Decimal"
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
