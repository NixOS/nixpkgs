{ stdenv
, lib
, fetchFromGitHub
, buildPythonPackage
, pkgconfig
, gmp
, pari
, mpfr
, fplll
, cython
, cysignals
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "fpylll";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fpylll";
    rev = version;
    hash = "sha256-T6l6hKzRDevlLyLu5H+bnEdl0OhsPer1coCDiftbPAk=";
  };

  buildInputs = [
    gmp
    pari
    mpfr
    fplll
  ];

  propagatedBuildInputs = [
    cython
    cysignals
    numpy
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    # Since upstream introduced --doctest-modules in
    # https://github.com/fplll/fpylll/commit/9732fdb40cf1bd43ad1f60762ec0a8401743fc79,
    # it is necessary to ignore import mismatches. Not sure why, but the files
    # should be identical anyway.
    PY_IGNORE_IMPORTMISMATCH=1 pytest
  '';

  meta = with lib; {
    description = "A Python interface for fplll";
    changelog = "https://github.com/fplll/fpylll/releases/tag/${version}";
    homepage = "https://github.com/fplll/fpylll";
    maintainers = teams.sage.members;
    license = licenses.gpl2Plus;
  };
}
