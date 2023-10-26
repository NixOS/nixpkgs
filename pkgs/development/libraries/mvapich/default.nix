{ lib, stdenv, fetchurl, pkg-config, bison, numactl, libxml2
, perl, gfortran, slurm, openssh, hwloc, zlib, makeWrapper
# InfiniBand dependencies
, opensm, rdma-core
# OmniPath dependencies
, libpsm2, libfabric
# Compile with slurm as a process manager
, useSlurm ? false
# Network type for MVAPICH2
, network ? "ethernet"
} :

assert builtins.elem network [ "ethernet" "infiniband" "omnipath" ];

stdenv.mkDerivation rec {
  pname = "mvapich";
  version = "2.3.7";

  src = fetchurl {
    url = "http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-${version}.tar.gz";
    sha256 = "sha256-w5pEkvS+UN9hAHhXSLoolOI85FCpQSgYHVFtpXV3Ua4=";
  };

  outputs = [ "out" "doc" "man" ];

  nativeBuildInputs = [ pkg-config bison makeWrapper gfortran ];
  propagatedBuildInputs = [ numactl rdma-core zlib opensm ];
  buildInputs = with lib; [
    numactl
    libxml2
    perl
    openssh
    hwloc
  ] ++ optionals (network == "infiniband") [ rdma-core opensm ]
    ++ optionals (network == "omnipath") [ libpsm2 libfabric ]
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
    ++ optional (network == "ethernet") "--with-device=ch3:sock"
    ++ optionals (network == "infiniband") [ "--with-device=ch3:mrail" "--with-rdma=gen2" ]
    ++ optionals (network == "omnipath") ["--with-device=ch3:psm" "--with-psm2=${libpsm2}"];

  doCheck = true;

  preFixup = ''
    # /tmp/nix-build... ends up in the RPATH, fix it manually
    for entry in $out/bin/mpichversion $out/bin/mpivars; do
      echo "fix rpath: $entry"
      patchelf --set-rpath "$out/lib" $entry
    done

    # Ensure the default compilers are the ones mvapich was built with
    substituteInPlace $out/bin/mpicc --replace 'CC="gcc"' 'CC=${stdenv.cc}/bin/cc'
    substituteInPlace $out/bin/mpicxx --replace 'CXX="g++"' 'CXX=${stdenv.cc}/bin/c++'
    substituteInPlace $out/bin/mpifort --replace 'FC="gfortran"' 'FC=${gfortran}/bin/gfortran'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "MPI-3.1 implementation optimized for Infiband transport";
    homepage = "https://mvapich.cse.ohio-state.edu";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
