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

  patches = [
    # Backport of two bugfixes (including a segfault):
    # https://github.com/aleaxit/gmpy/pull/217
    # https://github.com/aleaxit/gmpy/pull/218
    (fetchpatch {
      name = "bugfixes.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/gmpy2/patches/PR217_PR218_conversion_methods.patch?id=b7fbb9a4dac5d6882f6b83a57447dd79ecafb84c";
      sha256 = "1x3gwvqac36k4ypclxq37fcvi6p790k4xdpm2bj2b3xsvjb80ycz";
    })
  ];

  buildInputs = [ gmp mpfr libmpc ];

  meta = with stdenv.lib; {
    description = "GMP/MPIR, MPFR, and MPC interface to Python 2.6+ and 3.x";
    homepage = https://github.com/aleaxit/gmpy/;
    license = licenses.gpl3Plus;
  };
}
