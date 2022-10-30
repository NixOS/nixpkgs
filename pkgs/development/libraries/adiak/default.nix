{ lib, stdenv, fetchFromGitHub, cmake

# These should be either / or (or not at all, default)
, withOpenmpi? false, openmpi
, withMpich ? false, mpich
, shared ? !stdenv.hostPlatform.isStatic
}:

# This shows the original package specification for the spack package manager
# https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/adiak/package.py

let
   onOffBool = b: if b then "ON" else "OFF";
   withMPI = withMpich == true || withOpenmpi == true;
in

# We can't have both mpis being used (is this the right way to do this?)
assert (withMpich && !withOpenmpi) || (!withMpich && withOpenmpi) || (!withMpich && !withOpenmpi);

stdenv.mkDerivation rec {
  pname = "adiak";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "Adiak";
    rev = "950e3bfb91519ecb7b7ee7fa3063bfab23c0e2c9";
    hash = "sha256-3thZAvob06pwTga5+UePOf68ipX1oo+sMVYTspZd6Zk=";
    fetchSubmodules = true;
  };

  buildInputs = [ cmake ] ++

    # These shouldn't be both provided
    lib.optional withOpenmpi openmpi ++
    lib.optional withMpich mpich;

  # TODO how do these translate over (and is it needed)?
  # args.append("-DMPI_CXX_COMPILER=%s" % self.spec["mpi"].mpicxx)
  # args.append("-DMPI_C_COMPILER=%s" % self.spec["mpi"].mpicc)
  cmakeFlags = [
    "-DENABLE_MPI=${onOffBool withMPI}"
    "-DBUILD_SHARED_LIBS=${onOffBool shared}"
    "-DENABLE_TESTS=OFF"
  ];

  meta = with lib; {
    description = "Metadata collector for HPC application runs";
    longDescription = ''
      Collect metadata about HPC application runs and provide it
      to tools.
    '';
    homepage = "https://github.com/LLNL/Adiak";
    license = licenses.mit;
    maintainers = [ maintainers.vsoch ];
    platforms = platforms.linux;
  };
}
