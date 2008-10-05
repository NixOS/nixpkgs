args: with args;

stdenv.mkDerivation {
  name = "liblapack-3.1.1";
  src = fetchurl {
    url = http://www.netlib.org/lapack/lapack.tgz;
    sha256 = "0am0yzgqhaz6yzliaxc2cgm2mbqjzwcq70b01migk5231frkbhz4";
  };

  buildInputs = [gfortran];
  patches = [ ./gfortran.patch ];

  buildPhase = ''
    cp make.inc.example make.inc
    make blaslib
    # make lapacklib
    cd SRC
    make
  '';
  meta = {
    description     = "lapack library";
    license     = "Free, copyrighted";
    homepage    = http://www.netlib.org/lapac;
  };
}
