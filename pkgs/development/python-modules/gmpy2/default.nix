{ lib
, buildPythonPackage
, fetchFromGitHub
, isPyPy
, gmp
, mpfr
, libmpc

# Reverse dependency
, sage
, fetchpatch
}:

let
  pname = "gmpy2";
  version = "2.1.2";
  format = "setuptools";
in

buildPythonPackage {
  inherit pname version;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "aleaxit";
    repo = "gmpy";
    rev = "gmpy2-${version}";
    hash = "sha256-ARCttNzRA+Ji2j2NYaSCDXgvoEg01T9BnYadyqON2o0=";
  };

  patches = [
    # Broken for Python3.12
    # Fix from Arch Linux
    # https://gitlab.archlinux.org/archlinux/packaging/packages/python-gmpy2/-/commit/1c0d2d08d15b7b3bea012df2e91dbe0166be0afc
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/python-gmpy2/-/raw/1c0d2d08d15b7b3bea012df2e91dbe0166be0afc/python-3.12.patch";
      hash = "sha256-vHh66E2o/Tw/sCXC4XgA1GHWhQLG3iWhPw+4NN2GuJQ=";
    })
  ];

  buildInputs = [ gmp mpfr libmpc ];

  pythonImportsCheck = [ "gmpy2" ];

  passthru.tests = { inherit sage; };

  meta = with lib; {
    description = "GMP/MPIR, MPFR, and MPC interface to Python 2.6+ and 3.x";
    homepage = "https://github.com/aleaxit/gmpy/";
    license = licenses.gpl3Plus;
  };
}
