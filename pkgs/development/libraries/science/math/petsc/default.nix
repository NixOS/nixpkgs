{ lib
, stdenv
, fetchurl
, darwin
, gfortran
, python3
, blas
, lapack
, mpi                   # generic mpi dependency
, openssh               # required for openmpi tests
, petsc-withp4est ? true
, p4est
, zlib                  # propagated by p4est but required by petsc
}:

# This version of PETSc does not support a non-MPI p4est build
assert petsc-withp4est -> p4est.mpiSupport;

stdenv.mkDerivation rec {
  pname = "petsc";
  version = "3.19.2";

  src = fetchurl {
    url = "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${version}.tar.gz";
    sha256 = "sha256-EU82P3ebsWg5slwOcPiwrg2UfVDnL3xs3csRsAEHmxY=";
  };

  mpiSupport = !withp4est || p4est.mpiSupport;
  withp4est = petsc-withp4est;

  strictDeps = true;
  nativeBuildInputs = [ python3 gfortran ]
    ++ lib.optional mpiSupport mpi
    ++ lib.optional (mpiSupport && mpi.pname == "openmpi") openssh
  ;
  buildInputs = [ blas lapack ]
    ++ lib.optional withp4est p4est
  ;

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace config/install.py \
      --replace /usr/bin/install_name_tool ${darwin.cctools}/bin/install_name_tool
  '';

  # Both OpenMPI and MPICH get confused by the sandbox environment and spew errors like this (both to stdout and stderr):
  #     [hwloc/linux] failed to find sysfs cpu topology directory, aborting linux discovery.
  #     [1684747490.391106] [localhost:14258:0]       tcp_iface.c:837  UCX  ERROR opendir(/sys/class/net) failed: No such file or directory
  # These messages contaminate test output, which makes the quicktest suite to fail. The patch adds filtering for these messages.
  patches = [ ./filter_mpi_warnings.patch ];

  preConfigure = ''
    export FC="${gfortran}/bin/gfortran" F77="${gfortran}/bin/gfortran"
    patchShebangs ./lib/petsc/bin
    configureFlagsArray=(
      $configureFlagsArray
      ${if !mpiSupport then ''
        "--with-mpi=0"
      '' else ''
        "--CC=mpicc"
        "--with-cxx=mpicxx"
        "--with-fc=mpif90"
        "--with-mpi=1"
      ''}
      ${lib.optionalString withp4est ''
        "--with-p4est=1"
        "--with-zlib-include=${zlib.dev}/include"
        "--with-zlib-lib=-L${zlib}/lib -lz"
      ''}
      "--with-blas=1"
      "--with-lapack=1"
    )
  '';

  configureScript = "python ./configure";

  enableParallelBuilding = true;
  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  meta = with lib; {
    description = "Portable Extensible Toolkit for Scientific computation";
    homepage = "https://www.mcs.anl.gov/petsc/index.html";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cburstedde ];
  };
}
