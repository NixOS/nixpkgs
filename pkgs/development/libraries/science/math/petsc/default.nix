{ stdenv
, fetchurl
, blas
, gfortran
, liblapack
, python }:

stdenv.mkDerivation rec {
  pname = "petsc";
  version = "3.8.4";

  src = fetchurl {
    url = "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${version}.tar.gz";
    sha256 = "1iy49gagxncx09d88kxnwkj876p35683mpfk33x37165si6xqy4z";
  };

  nativeBuildInputs = [ blas gfortran.cc.lib liblapack python ];

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace config/install.py \
      --replace /usr/bin/install_name_tool install_name_tool
  '';

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
