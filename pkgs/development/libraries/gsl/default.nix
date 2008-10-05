args: with args;
stdenv.mkDerivation {
  name = "gsl-1.11";

  src = fetchurl {
    url = ftp://ftp.gnu.org/gnu/gsl/gsl-1.11.tar.gz;
    sha256 = "1c8ijbykgm6w8q0a1j3bfjdd9764fcw9v709bv7pqrgimq3ya4bn";
  };

  meta = { 
      description = "numerical library (>1000 functions)";
      homepage = http://www.gnu.org/software/gsl;
      license = "GPL2";
  };
}
