{ lib, stdenv, fetchFromGitHub, cmake, gcc, boost, eigen, libxml2, mpi, python3, petsc, pkg-config }:

stdenv.mkDerivation rec {
  pname = "precice";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "precice";
    repo = "precice";
    rev = "v${version}";
    hash = "sha256-AkIyrjL4OSqX6B1tt1QFopuwnkQaTtb4LmIssY3d3fQ=";
  };

  cmakeFlags = [
    "-DPRECICE_PETScMapping=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DPYTHON_LIBRARIES=${python3.libPrefix}"
    "-DPYTHON_INCLUDE_DIR=${python3}/include/${python3.libPrefix}"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.isDarwin [ "-D_GNU_SOURCE" ]
    # libxml2-2.12 changed const qualifiers
    ++ [ "-fpermissive" ]
  );

  nativeBuildInputs = [ cmake gcc pkg-config python3 python3.pkgs.numpy  ];
  buildInputs = [ boost eigen libxml2 mpi petsc ];

  meta = {
    description = "preCICE stands for Precise Code Interaction Coupling Environment";
    homepage = "https://precice.org/";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ Scriptkiddi ];
    mainProgram = "binprecice";
    platforms = lib.platforms.unix;
  };
}
