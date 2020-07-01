{ lib, stdenv, fetchFromGitHub, cmake, gcc, boost, eigen, libxml2, openmpi, python3, python3Packages, petsc }:

stdenv.mkDerivation rec {
  pname = "precice";
  version = "2.0.2";
  # Todo next release switch back to versioning but for python3 support master is needed

  src = fetchFromGitHub {
    owner = "precice";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s41wv2077d2gqj0wsxls6wkgdk9cgzcbmk2q43ha08ccq5i3dav";
  };

  cmakeFlags = [
    "-DPRECICE_PETScMapping=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DPYTHON_LIBRARIES=${python3.libPrefix}"
    "-DPYTHON_INCLUDE_DIR=${python3}/include/${python3.libPrefix}m"
  ];

  nativeBuildInputs = [ cmake gcc ];
  buildInputs = [ boost eigen libxml2 openmpi python3 python3Packages.numpy ];
  enableParallelBuilding = true;

  meta = {
    description = "preCICE stands for Precise Code Interaction Coupling Environment";
    license = with lib.licenses; [ gpl3 ];
    homepage = "https://www.precice.org/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
}


