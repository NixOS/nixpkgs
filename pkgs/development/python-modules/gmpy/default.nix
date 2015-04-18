{ stdenv, fetchurl, python, buildPythonPackage, gmp, mpfr, mpc }:

buildPythonPackage rec {
  name = "gmpy2-${ver}";
  ver = "2.0.4";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/g/gmpy2/${name}.zip";
    sha256 = "1kxypdbg77lbkvs0lx018jk88s7rc49z0xg5pkd0m5knv1snxc62";
  };

  # I think this it working fine, but I get a warning from tribler
  # I don't think adding mpc to PYTHONPATH will work either
  setupPyBuildFlags = [ "--prefix=${mpfr}" "--nompc" ];

  buildInputs =  [ gmp mpfr ];

  meta = {
    homepage = "http://www.gmpy.org/";
    description = "gmpy is a C-coded Python extension module that provides fast multiprecision arithmetic to Python";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.lgpl3;
  };
}
