{
  stdenv,
  lib,
  fetchFromGitLab,
  gfortran,
  autoreconfHook,
  fftwMpi,
  mpi,
}:

stdenv.mkDerivation rec {
  pname = "libvdwxc";
  # Stable version has non-working MPI detection.
  version = "unstable-24.02.2020";

  src = fetchFromGitLab {
    owner = "libvdwxc";
    repo = pname;
    rev = "92f4910c6ac88e111db2fb3a518089d0510c53b0";
    sha256 = "1c7pjrvifncbdyngs2bv185imxbcbq64nka8gshhp8n2ns6fids6";
  };

  nativeBuildInputs = [
    autoreconfHook
    gfortran
  ];

  buildInputs = [
    mpi
    fftwMpi
  ];

  preConfigure = ''
    mkdir build && cd build

    export PATH=$PATH:${mpi}/bin
    configureFlagsArray+=(
      --with-mpi=${lib.getDev mpi}
      CC=mpicc
      FC=mpif90
      MPICC=mpicc
      MPIFC=mpif90
    )
  '';

  configureScript = "../configure";

  hardeningDisable = [ "format" ];

  doCheck = true;

  meta = with lib; {
    description = "Portable C library of density functionals with van der Waals interactions for density functional theory";
    license = with licenses; [
      lgpl3Plus
      bsd3
    ];
    homepage = "https://libvdwxc.org/";
    platforms = platforms.unix;
    maintainers = [ maintainers.sheepforce ];
  };
}
