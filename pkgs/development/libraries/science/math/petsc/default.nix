{ stdenv , fetchurl , blas , gfortran , lapack , python }:

stdenv.mkDerivation rec {
  pname = "petsc";
  version = "3.13.1";

  src = fetchurl {
    url = "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${version}.tar.gz";
    sha256 = "0pr604b9pnryl9q0q5arlhs0xdx7wslca0sbz0pzs9qylmz775qp";
  };

  nativeBuildInputs = [ blas gfortran.cc.lib lapack python ];

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace config/install.py \
      --replace /usr/bin/install_name_tool install_name_tool
  '';

  preConfigure = ''
    patchShebangs .
    configureFlagsArray=(
      $configureFlagsArray
      "--CC=$CC"
      "--with-cxx=$CXX"
      "--with-fc=0"
      "--with-mpi=0"
      "--with-blas-lib=[${blas}/lib/libblas.so,${gfortran.cc.lib}/lib/libgfortran.a]"
      "--with-lapack-lib=[${lapack}/lib/liblapack.so,${gfortran.cc.lib}/lib/libgfortran.a]"
    )
  '';

  meta = with stdenv.lib; {
    description = ''
      Library of linear algebra algorithms for solving partial differential
      equations
    '';
    homepage = "https://www.mcs.anl.gov/petsc/index.html";
    license = licenses.bsd2;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
