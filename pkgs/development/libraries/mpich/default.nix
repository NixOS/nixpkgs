{ stdenv, fetchurl, perl, gfortran
,  openssh, hwloc
} :

stdenv.mkDerivation  rec {
  name = "mpich-${version}";
  version = "3.3";

  src = fetchurl {
    url = "https://www.mpich.org/static/downloads/${version}/mpich-${version}.tar.gz";
    sha256 = "02zs118q9n4xz9qnfc24i2r84vnzgnwnyyqanfv03lf3wqpy17ij";
  };

  configureFlags = [
    "--enable-shared"
    "--enable-sharedlib"
  ];

  enableParallelBuilding = true;

  buildInputs = [ perl gfortran openssh hwloc ];

  doCheck = true;

  preFixup = ''
    # Ensure the default compilers are the ones mpich was built with
    sed -i 's:CC="gcc":CC=${stdenv.cc}/bin/gcc:' $out/bin/mpicc
    sed -i 's:CXX="g++":CXX=${stdenv.cc}/bin/g++:' $out/bin/mpicxx
    sed -i 's:FC="gfortran":FC=${gfortran}/bin/gfortran:' $out/bin/mpifort
  ''
  + stdenv.lib.optionalString (!stdenv.isDarwin) ''
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
    platforms = platforms.linux ++ platforms.darwin;
  };
}
