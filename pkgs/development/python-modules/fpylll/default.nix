{ lib
, fetchFromGitHub
, buildPythonPackage

# build-system
, cysignals
, cython_3
, pkgconfig
, setuptools

, gmp
, pari
, mpfr
, fplll
, numpy

# tests
, pytestCheckHook
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

  nativeBuildInputs = [
    cython_3
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

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # Since upstream introduced --doctest-modules in
    # https://github.com/fplll/fpylll/commit/9732fdb40cf1bd43ad1f60762ec0a8401743fc79,
    # it is necessary to ignore import mismatches. Not sure why, but the files
    # should be identical anyway.
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  meta = with lib; {
    description = "A Python interface for fplll";
    changelog = "https://github.com/fplll/fpylll/releases/tag/${version}";
    homepage = "https://github.com/fplll/fpylll";
    maintainers = teams.sage.members;
    license = licenses.gpl2Plus;
  };
}
