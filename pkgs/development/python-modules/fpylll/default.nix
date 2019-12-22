{ lib
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
  version = "0.5.1dev";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fpylll";
    rev = version;
    sha256 = "15vdfgx448mr1nf054h7lr2j3dd35fsfhikqzrh9zsng8n12hxa5";
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

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    # Since upstream introduced --doctest-modules in
    # https://github.com/fplll/fpylll/commit/9732fdb40cf1bd43ad1f60762ec0a8401743fc79,
    # it is necessary to ignore import mismatches. Not sure why, but the files
    # should be identical anyway.
    PY_IGNORE_IMPORTMISMATCH=1 pytest
  '';

  meta = {
    description = "A Python interface for fplll";
    changelog = "https://github.com/fplll/fpylll/releases/tag/${version}";
    homepage = https://github.com/fplll/fpylll;
    maintainers = with lib.maintainers; [ timokau ];
    license = lib.licenses.gpl2Plus;
  };
}
