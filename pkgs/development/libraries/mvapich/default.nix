{ lib, stdenv, fetchurl, pkg-config, bison, numactl, libxml2
, perl, gfortran, slurm, openssh, hwloc, zlib, makeWrapper
# InfiniBand/Ethernet dependencies
, ucx
# OmniPath dependencies
, libfabric
# Compile with slurm as a process manager
, useSlurm ? false
# Network type for MVAPICH2
, network ? "ucx"
} :

assert builtins.elem network [ "ucx" "ofi" ];

stdenv.mkDerivation rec {
  pname = "mvapich";
  version = "3.0";

  src = fetchurl {
    url = "https://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich-${version}.tar.gz";
    sha256 = "sha256-7gdsTmctGNa/jdIlDkqR+paqwdsseI5FcrVRPYaTbvs=";
  };

  outputs = [ "out" "doc" "man" ];

  nativeBuildInputs = [ pkg-config bison makeWrapper gfortran ];
  propagatedBuildInputs = [ numactl zlib ];
  buildInputs = with lib; [
    libxml2
    perl
    openssh
    hwloc
  ] ++ optional (network == "ucx") ucx
    ++ optional (network == "ofi") libfabric
    ++ optional useSlurm slurm;

  configureFlags = with lib; [
    "--with-pm=hydra"
    "--enable-fortran=all"
    "--enable-cxx"
    "--enable-threads=multiple"
    "--enable-hybrid"
    "--enable-shared"
    "FFLAGS=-fallow-argument-mismatch" # fix build with gfortran 10
  ] ++ optional useSlurm "--with-pm=slurm"
    ++ optional (network == "ucx") "--with-device=ch4:ucx"
    ++ optional (network == "ofi") "--with-device=ch4:ofi";

  doCheck = true;

  preFixup = ''
    # Ensure the default compilers are the ones mvapich was built with
    substituteInPlace $out/bin/mpicc --replace 'CC="gcc"' 'CC=${stdenv.cc}/bin/cc'
    substituteInPlace $out/bin/mpicxx --replace 'CXX="g++"' 'CXX=${stdenv.cc}/bin/c++'
    substituteInPlace $out/bin/mpifort --replace 'FC="gfortran"' 'FC=${gfortran}/bin/gfortran'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "MPI-3.1 implementation optimized for Infiband and OmniPath transport";
    homepage = "https://mvapich.cse.ohio-state.edu";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
