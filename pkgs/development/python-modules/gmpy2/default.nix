{ stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, isPyPy
, gmp
, mpfr
, libmpc
}:

let
  pname = "gmpy2";
  version = "2.1.0b5";
in

buildPythonPackage {
  inherit pname version;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "aleaxit";
    repo = "gmpy";
    rev = "gmpy2-${version}";
    sha256 = "1mqzyp7qwqqyk6jbicgx22svdy2106xwhmhfvdf0vpnmwswcxclb";
  };

  buildInputs = [ gmp mpfr libmpc ];

  meta = with stdenv.lib; {
    description = "GMP/MPIR, MPFR, and MPC interface to Python 2.6+ and 3.x";
    homepage = "https://github.com/aleaxit/gmpy/";
    license = licenses.gpl3Plus;
  };
}
