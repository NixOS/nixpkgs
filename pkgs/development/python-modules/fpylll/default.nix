{ lib
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
  version = "0.5.1dev";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fpylll";
    rev = version;
    sha256 = "15vdfgx448mr1nf054h7lr2j3dd35fsfhikqzrh9zsng8n12hxa5";
  };

  patches = [
    # two patches to fix the testsuite on aarch64 (https://github.com/fplll/fpylll/issues/162)
    (fetchpatch {
      url = "https://github.com/fplll/fpylll/commit/d5809a8fdb86b2693b1fa94e655bbbe4ad80e286.patch";
      name = "less-precision-in-tests.patch";
      sha256 = "0vkvi25nwwvk5r4a4xmkbf060di4hjq32bys75l2hsaysxmk93nz";
    })
    (fetchpatch {
      url = "https://github.com/fplll/fpylll/commit/b5b146a010d50da219a313adc4b6f7deddcc146b.patch";
      name = "dont-hardcode-precision.patch";
      sha256 = "1rsbwh90i1j5p2rp6jd5n25v1jzw1n8728fzz1lhb91zmk0hlxc9";
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
