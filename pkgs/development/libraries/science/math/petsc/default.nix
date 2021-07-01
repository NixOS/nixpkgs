{ lib
, stdenv
, fetchurl
, darwin
, gfortran
, python
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
  version = "3.14.2";

  src = fetchurl {
    url = "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${version}.tar.gz";
    sha256 = "04vy3qyakikslc58qyv8c9qrwlivix3w6znc993i37cvfg99dch9";
  };

  mpiSupport = !withp4est || p4est.mpiSupport;
  withp4est = petsc-withp4est;

  nativeBuildInputs = [ python gfortran ];
  buildInputs = [ blas lapack ]
    ++ lib.optional mpiSupport mpi
    ++ lib.optional (mpiSupport && mpi.pname == "openmpi") openssh
    ++ lib.optional withp4est p4est
  ;

  # Upstream does some hot she-py-bang stuff, this change streamlines that
  # process. The original script in upstream is both a shell script and a
  # python script, where the shellscript just finds a suitable python
  # interpreter to execute the python script. See
  # https://github.com/NixOS/nixpkgs/pull/89299#discussion_r450203444
  # for more details.
  prePatch = ''
    substituteInPlace configure \
      --replace /bin/sh /usr/bin/python
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace config/install.py \
      --replace /usr/bin/install_name_tool ${darwin.cctools}/bin/install_name_tool
  '';

  preConfigure = ''
    export FC="${gfortran}/bin/gfortran" F77="${gfortran}/bin/gfortran"
    patchShebangs .
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
      ${if withp4est then ''
        "--with-p4est=1"
        "--with-zlib-include=${zlib.dev}/include"
        "--with-zlib-lib=-L${zlib}/lib -lz"
      '' else ""}
      "--with-blas=1"
      "--with-lapack=1"
    )
  '';

  enableParallelBuilding = true;
  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  meta = with lib; {
    description = "Portable Extensible Toolkit for Scientific computation";
    homepage = "https://www.mcs.anl.gov/petsc/index.html";
    license = licenses.bsd2;
    maintainers = with maintainers; [ wucke13 cburstedde ];
  };
}
