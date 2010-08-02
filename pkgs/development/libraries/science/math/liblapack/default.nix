{ stdenv, fetchurl, gfortran, blas }:

stdenv.mkDerivation {
  name = "liblapack-3.2.1";
  src = fetchurl {
    url = "http://www.netlib.org/lapack/lapack-3.2.1.tgz";
    sha256 = "5825f83971157001fd4235514afe8ff5fc16e1c06b2e872e442c242efd6c166d";
  };

  buildInputs = [gfortran blas];
  patches = [ ./blas-link.patch ];

  configurePhase = ''
    echo >make.inc  "SHELL = ${stdenv.shell}"
    echo >>make.inc "PLAT ="
    echo >>make.inc "FORTRAN = gfortran"
    echo >>make.inc "OPTS = -O2 -fPIC"
    echo >>make.inc "DRVOPTS = \$(OPTS)"
    echo >>make.inc "NOOPT = -O0 -fPIC"
    echo >>make.inc "LOADER = gfortran"
    echo >>make.inc "LOADOPTS ="
    echo >>make.inc "TIMER = INT_ETIME"
    echo >>make.inc "ARCH = gfortran"
    echo >>make.inc "ARCHFLAGS = -shared -o"
    echo >>make.inc "RANLIB = echo"
    echo >>make.inc "BLASLIB = -lblas"
    echo >>make.inc "LAPACKLIB = liblapack.so.3"
    echo >>make.inc "TMGLIB = libtmglib.so.3"
    echo >>make.inc "EIGSRCLIB = libeigsrc.so.3"
    echo >>make.inc "LINSRCLIB = liblinsrc.so.3"
  '';

  buildPhase = ''
    make clean
    make lib
    echo >make.inc  "SHELL = ${stdenv.shell}"
    echo >>make.inc "PLAT ="
    echo >>make.inc "FORTRAN = gfortran"
    echo >>make.inc "OPTS = -O2 -fPIC"
    echo >>make.inc "DRVOPTS = \$(OPTS)"
    echo >>make.inc "NOOPT = -O0 -fPIC"
    echo >>make.inc "LOADER = gfortran"
    echo >>make.inc "LOADOPTS = "
    echo >>make.inc "TIMER = INT_ETIME"
    echo >>make.inc "ARCH = ar rcs"
    echo >>make.inc "RANLIB = ranlib"
    echo >>make.inc "BLASLIB = "
    echo >>make.inc "ARCHFLAGS ="
    echo >>make.inc "LAPACKLIB    = liblapack.a"
    echo >>make.inc "TMGLIB       = tmglib.a"
    echo >>make.inc "EIGSRCLIB    = eigsrc.a"
    echo >>make.inc "LINSRCLIB    = linsrc.a"
    make clean
    make lib
  '';

  installPhase = ''
    ensureDir "$out/lib"
    install -m755 *.a* "$out/lib"
    install -m755 *.so* "$out/lib"
    ln -sf liblapack.so.3 "$out/lib/liblapack.so"
    ln -sf libtmglib.so.3 "$out/lib/libtmglib.so"
  '';

  meta = {
    description = "Linear Algebra PACKage";
    license = "revised-BSD";
    homepage = "http://www.netlib.org/lapack/";
  };
}
