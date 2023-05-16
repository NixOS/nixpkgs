{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, gmpy2
, isPyPy
, setuptools
=======
, fetchPypi
, fetchpatch
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mpmath";
<<<<<<< HEAD
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mpmath";
    repo = "mpmath";
    rev = "refs/tags/${version}";
    hash = "sha256-9BGcaC3TyolGeO65/H42T/WQY6z5vc1h+MA+8MGFChU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  passthru.optional-dependencies = {
    gmpy = lib.optionals (!isPyPy) [
      gmpy2
    ];
  };
=======
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "79ffb45cf9f4b101a807595bcb3e72e0396202e0b1d25d689134b48c4216a81a";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-29063.patch";
      url = "https://github.com/fredrik-johansson/mpmath/commit/46d44c3c8f3244017fe1eb102d564eb4ab8ef750.patch";
      hash = "sha256-DaZ6nj9rEsjTAomu481Ujun364bL5E6lkXFvgBfHyeA=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage    = "https://mpmath.org/";
    description = "A pure-Python library for multiprecision floating arithmetic";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
