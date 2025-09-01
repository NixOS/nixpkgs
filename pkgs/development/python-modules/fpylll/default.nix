{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

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
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fpylll";
    tag = version;
    hash = "sha256-vks4rTXk6fh8183PCxJzfTXQyo3scBH4afjbQAkT6Gw=";
  };

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

  propagatedBuildInputs = [
    numpy
    cysignals
  ];

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
    description = "Python interface for fplll";
    changelog = "https://github.com/fplll/fpylll/releases/tag/${src.tag}";
    homepage = "https://github.com/fplll/fpylll";
    teams = [ teams.sage ];
    license = licenses.gpl2Plus;
  };
}
