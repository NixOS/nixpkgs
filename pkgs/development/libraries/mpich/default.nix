{ stdenv, lib, fetchurl, perl, gfortran
, openssh, hwloc, python3
# either libfabric or ucx work for ch4backend on linux. On darwin, neither of
# these libraries currently build so this argument is ignored on Darwin.
, ch4backend
# Process managers to build (`--with-pm`),
# cf. https://github.com/pmodels/mpich/blob/b80a6d7c24defe7cdf6c57c52430f8075a0a41d6/README.vin#L562-L586
, withPm ? [ "hydra" "gforker" ]
, pmix
# PMIX support is likely incompatible with process managers (`--with-pm`)
# https://github.com/NixOS/nixpkgs/pull/274804#discussion_r1432601476
, pmixSupport ? false
} :

let
  withPmStr = if withPm != [ ] then builtins.concatStringsSep ":" withPm else "no";
in

assert (ch4backend.pname == "ucx" || ch4backend.pname == "libfabric");

stdenv.mkDerivation  rec {
  pname = "mpich";
  version = "4.1.2";

  src = fetchurl {
    url = "https://www.mpich.org/static/downloads/${version}/mpich-${version}.tar.gz";
    sha256 = "sha256-NJLpitq2K1l+8NKS+yRZthI7yABwqKoKML5pYgdaEvA=";
  };

  outputs = [ "out" "doc" "man" ];

  configureFlags = [
    "--enable-shared"
    "--with-pm=${withPmStr}"
  ] ++ lib.optionals (lib.versionAtLeast gfortran.version "10") [
    "FFLAGS=-fallow-argument-mismatch" # https://github.com/pmodels/mpich/issues/4300
    "FCFLAGS=-fallow-argument-mismatch"
  ] ++ lib.optionals pmixSupport [
    "--with-pmix"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ gfortran python3 ];
  buildInputs = [ perl openssh hwloc ]
    ++ lib.optional (!stdenv.isDarwin) ch4backend
    ++ lib.optional pmixSupport pmix;


  doCheck = true;

  preFixup = ''
    # Ensure the default compilers are the ones mpich was built with
    sed -i 's:CC="gcc":CC=${stdenv.cc}/bin/gcc:' $out/bin/mpicc
    sed -i 's:CXX="g++":CXX=${stdenv.cc}/bin/g++:' $out/bin/mpicxx
    sed -i 's:FC="gfortran":FC=${gfortran}/bin/gfortran:' $out/bin/mpifort
  '';

  meta = with lib; {
    # As far as we know, --with-pmix silently disables all of `--with-pm`
    broken = pmixSupport && withPm != [ ];

    description = "Implementation of the Message Passing Interface (MPI) standard";

    longDescription = ''
      MPICH2 is a free high-performance and portable implementation of
      the Message Passing Interface (MPI) standard, both version 1 and
      version 2.
    '';
    homepage = "http://www.mcs.anl.gov/mpi/mpich2/";
    license = {
      url = "http://git.mpich.org/mpich.git/blob/a385d6d0d55e83c3709ae851967ce613e892cd21:/COPYRIGHT";
      fullName = "MPICH license (permissive)";
    };
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
