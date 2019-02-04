{ stdenv
, fetchurl
, gfortran
, pkgconfig
, python2
, blas
, hdf5
, hypre
, liblapack
, metis
, mumps
, openmpi
, openssh
, scalapack
, scotch
, spai
, suitesparse
, superlu
, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  version = "3.10.3";
  name = "petsc-${version}";

  src = fetchurl {
    url = "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${version}.tar.gz";
    sha256 = "1r4dvkrmsx2sxzm7krwvji4c1pl4girmihj0xr7n14g0pamnn46d";
  };

  nativeBuildInputs = [
    gfortran
    pkgconfig
    python2
  ] ++ stdenv.lib.optional stdenv.isDarwin [ fixDarwinDylibNames ];

  buildInputs = [
    blas
    hdf5
    hypre
    liblapack
    metis
    mumps
    openmpi
    openssh
    scalapack
    scotch
    spai
    suitesparse
    superlu
  ];

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace config/install.py \
      --replace /usr/bin/install_name_tool install_name_tool
    substituteInPlace config/BuildSystem/config/packages/MUMPS.py \
      --replace "'libmpiseq.a'" ""
  '';

  preConfigure = ''
    patchShebangs .
  '';

  configureFlags = [
    "--COPTFLAGS=\"-g -O2\""
    "--CXXOPTFLAGS=\"-g -O2\""
    "--with-debugging=yes"
    "--with-fortran-bindings=no"
    "--with-hdf5-dir=${hdf5}"
    "--with-hypre-dir=${hypre}"
    "--with-metis-dir=${metis}"
    "--with-mumps-dir=${mumps}"
    "--with-scalapack-dir=${scalapack}"
    "--with-ptscotch-dir=${scotch}"
    "--with-spai-dir=${spai}"
    "--with-suitesparse-dir=${suitesparse}"
    "--with-superlu-dir=${superlu}"
  ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "Library of linear algebra algorithms for solving partial differential equations";
    homepage = https://www.mcs.anl.gov/petsc/index.html;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ jamtrott ];
  };
}
