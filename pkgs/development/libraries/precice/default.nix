{ lib, stdenv, fetchFromGitHub, cmake, gcc, boost, eigen, libxml2, openmpi, python3, petsc }:

stdenv.mkDerivation rec {
  pname = "precice";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "precice";
    repo = pname;
    rev = "v${version}";
    sha256 = "180db4nlir2409wzdnsc1bkyrllnki8d551qbm1rg82zkz3vdmqg";
  };

  cmakeFlags = [
    "-DPRECICE_PETScMapping=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DPYTHON_LIBRARIES=${python3.libPrefix}"
    "-DPYTHON_INCLUDE_DIR=${python3}/include/${python3.libPrefix}"
  ];

  NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin [ "-D_GNU_SOURCE" ];

  nativeBuildInputs = [ cmake gcc ];
  buildInputs = [ boost eigen libxml2 openmpi python3 python3.pkgs.numpy ];
  enableParallelBuilding = true;

  meta = {
    description = "preCICE stands for Precise Code Interaction Coupling Environment";
    license = with lib.licenses; [ gpl3 ];
    homepage = "https://www.precice.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
}


