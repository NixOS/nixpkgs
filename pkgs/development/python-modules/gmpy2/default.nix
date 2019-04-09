{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPyPy
, gmp
, mpfr
, libmpc
}:

let
  pname = "gmpy2";
  version = "2.1a4";
in

buildPythonPackage {
  inherit pname version;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "aleaxit";
    repo = "gmpy";
    rev = "gmpy2-${version}";
    sha256 = "1wg4w4q2l7n26ksrdh4rwqmifgfm32n7x29cgdvmmbv5lmilb5hz";
  };

  buildInputs = [ gmp mpfr libmpc ];

  meta = with stdenv.lib; {
    description = "GMP/MPIR, MPFR, and MPC interface to Python 2.6+ and 3.x";
    homepage = https://github.com/aleaxit/gmpy/;
    license = licenses.gpl3Plus;
  };
}
