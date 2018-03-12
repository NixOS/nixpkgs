{ stdenv, fetchurl, python, perl, gfortran
, slurm, openssh, hwloc
} :

stdenv.mkDerivation  rec {
  name = "mpich-${version}";
  version = "3.2.1";

  src = fetchurl {
    url = "http://www.mpich.org/static/downloads/${version}/mpich-${version}.tar.gz";
    sha256 = "1w9h4g7d46d9l5jbcyfxpaqzpjrc5hyvr9d0ns7278psxpr3pdax";
  };

  configureFlags = [
    "--enable-shared"
    "--enable-sharedlib"
  ];

  buildInputs = [ perl gfortran slurm openssh hwloc ];

  doCheck = true;

  preFixup = ''
    # /tmp/nix-build... ends up in the RPATH, fix it manually
    for entry in $out/bin/mpichversion $out/bin/mpivars; do
      echo "fix rpath: $entry"
      patchelf --set-rpath "$out/lib" $entry
    done
  '';


  meta = with stdenv.lib; {
    description = "Implementation of the Message Passing Interface (MPI) standard";

    longDescription = ''
      MPICH2 is a free high-performance and portable implementation of
      the Message Passing Interface (MPI) standard, both version 1 and
      version 2.
    '';
    homepage = http://www.mcs.anl.gov/mpi/mpich2/;
    license = {
      url = http://git.mpich.org/mpich.git/blob/a385d6d0d55e83c3709ae851967ce613e892cd21:/COPYRIGHT;
      fullName = "MPICH license (permissive)";
    };
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.unix;
  };
}
