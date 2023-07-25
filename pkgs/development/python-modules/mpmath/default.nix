{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mpmath";
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
