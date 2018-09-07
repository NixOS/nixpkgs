{ stdenv, buildPythonPackage, fetchurl, isPyPy, gmp, mpfr, libmpc } :

let
  pname = "gmpy2";
  version = "2.0.8";
in

buildPythonPackage {
  inherit pname version;

  disabled = isPyPy;

  src = fetchurl {
    url = "mirror://pypi/g/gmpy2/${pname}-${version}.zip";
    sha256 = "0grx6zmi99iaslm07w6c2aqpnmbkgrxcqjrqpfq223xri0r3w8yx";
  };

  buildInputs = [ gmp mpfr libmpc ];

  meta = with stdenv.lib; {
    description = "GMP/MPIR, MPFR, and MPC interface to Python 2.6+ and 3.x";
    homepage = http://code.google.com/p/gmpy/;
    license = licenses.gpl3Plus;
  };
}
