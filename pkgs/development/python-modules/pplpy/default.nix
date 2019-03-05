{ lib
, fetchPypi
, buildPythonPackage
, gmp
, mpfr
, libmpc
, ppl
, pari
, cython
, cysignals
, gmpy2_2_1
}:

buildPythonPackage rec {
  pname = "pplpy";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dk8l5r3f2jbkkasddvxwvhlq35pjsiirh801lrapv8lb16r2qmr";
  };

  buildInputs = [
    gmp
    mpfr
    libmpc
    ppl
  ];

  propagatedBuildInputs = [
    cython
    cysignals
    gmpy2_2_1
  ];

  meta = with lib; {
    description = "A Python wrapper for ppl";
    homepage = https://gitlab.com/videlec/pplpy;
    maintainers = with maintainers; [ timokau ];
    license = licenses.gpl3;
  };
}
