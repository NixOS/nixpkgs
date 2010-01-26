{ stdenv, fetchurl, gfortran }:

stdenv.mkDerivation {
  name = "blas-20070405";
  src = fetchurl {
    url = "http://www.netlib.org/blas/blas.tgz";
    sha256 = "07alzd2yxkah96vjczqwi3ld5w00bvqv7qxb2fayvhs1h64jabxw";
  };

  buildInputs = [gfortran];

  configurePhase = ''
    echo >make.inc  "SHELL = ${stdenv.bash}/bin/bash"
    echo >>make.inc "PLAT = _LINUX"
    echo >>make.inc "FORTRAN = gfortran"
    echo >>make.inc "OPTS = -O2 -fPIC"
    echo >>make.inc "DRVOPTS = $$(OPTS)"
    echo >>make.inc "NOOPT = -O0 -fPIC"
    echo >>make.inc "LOADER = gfortran"
    echo >>make.inc "LOADOPTS ="
    echo >>make.inc "ARCH = gfortran"
    echo >>make.inc "ARCHFLAGS = -shared -o"
    echo >>make.inc "RANLIB = echo"
    echo >>make.inc "BLASLIB = libblas.so.3.0.3"
  '';

  installPhase = ''
    install -D -m755 libblas.so.3.0.3 "$out/lib/libblas.so.3.0.3"
    ln -s libblas.so.3.0.3 "$out/lib/libblas.so.3"
    ln -s libblas.so.3.0.3 "$out/lib/libblas.so"
  '';

  meta = {
    description = "Basic Linear Algebra Subprograms";
    license = "Free, copyrighted";
    homepage = "http://www.netlib.org/blas/";
  };
}
