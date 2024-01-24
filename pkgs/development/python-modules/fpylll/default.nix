{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage

# build-system
, cysignals
, cython
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
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fpylll";
    rev = "refs/tags/${version}";
    hash = "sha256-EyReCkVRb3CgzIRal5H13OX/UdwWi+evDe7PoS1qP4A=";
  };

  # temporarily revert to cython 0.29
  patches = [
    (fetchpatch {
      url = "https://github.com/fplll/fpylll/commit/528243c6fa6491c8e9652b99bdf9758766273d66.diff";
      revert = true;
      sha256 = "sha256-IRppkESy0CRwARhxBAsZxP6JkTe0M91apG4CTSSYNUU=";
      excludes = ["requirements.txt"];
    })
  ];
  postPatch = ''
    substituteInPlace requirements.txt --replace "Cython>=3.0" "Cython"
  '';

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
