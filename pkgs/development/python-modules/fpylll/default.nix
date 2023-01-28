{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fpylll";
    rev = version;
    sha256 = "sha256-iUPreJ8BSB8LDisbJis0xn8ld6+Nf9Z4AP8SWJlCfZg=";
  };

  patches = [
   (fetchpatch {
     name = "remove-strategies-doctest.patch";
     url = "https://github.com/fplll/fpylll/commit/3edffcd189e9d827a322d83b0f84d32e5f067442.patch";
     sha256 = "sha256-U7qOIbVzUNwYmjOPryjnE3J+MX/vMwm3T0UyOZ5ylLc=";
   })
  ];

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
