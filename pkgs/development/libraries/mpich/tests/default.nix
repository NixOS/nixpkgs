{
  stdenv,
  cmake,
  mpi,
  mpich,
}:
stdenv.mkDerivation {
  pname = "${mpich.pname}-samples-${mpi.pname}";
  inherit (mpich) version src;

  # Interacting with autotools is cumbersome, so we build a small subset of
  # examples using CMake instead.
  postPatch = ''
    cd examples
    cat ${./CMakeLists.txt} > CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ mpi ];

  passthru = {
    inherit mpi;
  };

  # A simple MPI program that approximates Pi
  meta.mainProgram = "cpi";
}
