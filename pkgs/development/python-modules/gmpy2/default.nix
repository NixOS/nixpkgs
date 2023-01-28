{ lib
, buildPythonPackage
, fetchFromGitHub
, isPyPy
, gmp
, mpfr
, libmpc
}:

let
  pname = "gmpy2";
  version = "2.1.2";
in

buildPythonPackage {
  inherit pname version;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "aleaxit";
    repo = "gmpy";
    rev = "gmpy2-${version}";
    sha256 = "sha256-ARCttNzRA+Ji2j2NYaSCDXgvoEg01T9BnYadyqON2o0=";
  };

  buildInputs = [ gmp mpfr libmpc ];

  pythonImportsCheck = [ "gmpy2" ];

  meta = with lib; {
    description = "GMP/MPIR, MPFR, and MPC interface to Python 2.6+ and 3.x";
    homepage = "https://github.com/aleaxit/gmpy/";
    license = licenses.gpl3Plus;
  };
}
