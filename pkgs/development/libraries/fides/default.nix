{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, cmake
, adios2
, vtk-m
, rapidjson
}:

stdenv.mkDerivation rec {
  pname = "fides";
  version = "1.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.kitware.com";
    owner = "vtk";
    repo = "fides";
    rev = "v${version}";
    sha256 = "oquvV6kyb4b3j0oAKYxUtfjatrZp+7j07y4B1UeMKlA=";
  };

  patches = [
    # Fix missing header includes.
    (fetchpatch {
      url = "https://gitlab.kitware.com/vtk/fides/-/commit/eb7cd4567e5805f52a657ce70e2596aaa9e735f6.patch";
      sha256 = "gh5WJCIOvBgy8Y+bes/oCnvlALnRRhHqnZLSENfv5vk=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    adios2
    vtk-m
    rapidjson
  ];

  cmakeFlags = [
    "-DFIDES_USE_EXTERNAL_RAPIDJSON=ON"
  ];

  dontUseCmakeBuildDir = true;

  preConfigure = ''
    # VTK-m does not install targets when `CMAKE_BINARY_DIR=/build/source/build`, thinking it is building itself.
    # https://gitlab.kitware.com/vtk/vtk-m/-/blob/3b8ead6cb2444fcf50e8f5a5d188d08095ecb95a/CMake/VTKmConfig.cmake.in#L109
    mkdir -p _build
    cd _build
    cmakeDir=..
  '';

  meta = with lib; {
    description = "Library that enables interoperable analysis and visualization services with ADIOS2-enabled simulations";
    homepage = "https://gitlab.kitware.com/vtk/fides";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
