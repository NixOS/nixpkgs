{ lib, stdenv, fetchFromGitHub, cmake, gcc, boost, eigen, libxml2, mpi, python3, petsc }:

stdenv.mkDerivation rec {
  pname = "precice";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "precice";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qmwdxpbmy4dvjxav3dls18qns734j0yfvxvjrh1nnkk36qhfp3q";
  };

  cmakeFlags = [
    "-DPRECICE_PETScMapping=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DPYTHON_LIBRARIES=${python3.libPrefix}"
    "-DPYTHON_INCLUDE_DIR=${python3}/include/${python3.libPrefix}"
  ];

  NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin [ "-D_GNU_SOURCE" ];

  nativeBuildInputs = [ cmake gcc ];
  buildInputs = [ boost eigen libxml2 mpi python3 python3.pkgs.numpy ];

  meta = {
    description = "preCICE stands for Precise Code Interaction Coupling Environment";
    homepage = "https://precice.org/";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ Scriptkiddi ];
    mainProgram = "binprecice";
    platforms = lib.platforms.unix;
  };
}


