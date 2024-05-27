{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  fetchpatch,

  # build-system
  cysignals,
  cython,
  pkgconfig,
  setuptools,

  gmp,
  pari,
  mpfr,
  fplll,
  numpy,

  # Reverse dependency
  sage,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fpylll";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fpylll";
    rev = "refs/tags/${version}";
    hash = "sha256-M3ZnDL0Ui3UAa5Jn/Wr5pAHhghP7EAaQD/sx5QZ58ZQ=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/fplll/fpylll/commit/fc432b21fa7e4b9891f5b761b3539989eb958f2b.diff";
      hash = "sha256-+UidQ5xnlmjeVeVvR4J2zDzAuXP5LUPXCh4RP4o9oGA=";
    })
    (fetchpatch {
      url = "https://github.com/fplll/fpylll/commit/cece9c9b182dc3ac2c9121549cb427ccf4c4a9fe.diff";
      hash = "sha256-epJb8gorQ7gEEylZ2yZFdM9+EZ4ys9mUUUPiJ2D0VOM=";
    })
  ];

  nativeBuildInputs = [
    cython
    cysignals
    pkgconfig
    setuptools
  ];

  buildInputs = [
    gmp
    pari
    mpfr
    fplll
  ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # Since upstream introduced --doctest-modules in
    # https://github.com/fplll/fpylll/commit/9732fdb40cf1bd43ad1f60762ec0a8401743fc79,
    # it is necessary to ignore import mismatches. Not sure why, but the files
    # should be identical anyway.
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  passthru.tests = {
    inherit sage;
  };

  meta = with lib; {
    description = "A Python interface for fplll";
    changelog = "https://github.com/fplll/fpylll/releases/tag/${version}";
    homepage = "https://github.com/fplll/fpylll";
    maintainers = teams.sage.members;
    license = licenses.gpl2Plus;
  };
}
