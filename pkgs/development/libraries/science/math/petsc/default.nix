{ stdenv
, fetchurl
, blas
, gfortran
, liblapack
, python }:

stdenv.mkDerivation rec {
  name = "petsc-${version}";
  version = "3.7.6";

  src = fetchurl {
    url = "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${version}.tar.gz";
    sha256 = "0jfl35lrhzvv982z6h1v5rcp39g0x16ca43rm9dx91wm6i8y13iw";
  };

  nativeBuildInputs = [ blas gfortran.cc.lib liblapack python ];

  preConfigure = ''
    patchShebangs .
    configureFlagsArray=(
      $configureFlagsArray
      "--CC=$CC"
      "--with-cxx=0"
      "--with-fc=0"
      "--with-mpi=0"
      "--with-blas-lib=[${blas}/lib/libblas.a,${gfortran.cc.lib}/lib/libgfortran.a]"
      "--with-lapack-lib=[${liblapack}/lib/liblapack.a,${gfortran.cc.lib}/lib/libgfortran.a]"
    )
  '';

  postInstall = ''
    rm $out/bin/petscmpiexec
    rm $out/bin/popup
    rm $out/bin/uncrustify.cfg
    rm -rf $out/bin/win32fe
  '';

  meta = {
    description = "Library of linear algebra algorithms for solving partial differential equations";
    homepage = https://www.mcs.anl.gov/petsc/index.html;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd2;
  };
}
