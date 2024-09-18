{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  pythonOlder,
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
  version = "2.2.0a2";
  pyproject = true;

  disabled = isPyPy || pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aleaxit";
    repo = "gmpy";
    rev = "refs/tags/gmpy2-${version}";
    hash = "sha256-luLEDEY1cezhzZo4fXmM/MUg2YyAaz7n0HwSpbNayP8=";
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
    lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
      # issue with some overflow logic
      "test_mpz_to_bytes"
      "test_mpz_from_bytes"
    ]
    ++ lib.optionals stdenv.isDarwin [
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
