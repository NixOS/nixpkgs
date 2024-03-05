{ lib
, buildPythonPackage
, fetchFromGitHub
, gmpy2
, isPyPy
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mpmath";
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
}
