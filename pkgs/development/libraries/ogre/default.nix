{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, unzip
, SDL2
, boost
, freeimage
, freetype
, libpng
, ois
, pugixml
, zziplib
  # linux
, freeglut
, libGL
, libGLU
, libICE
, libSM
, libX11
, libXaw
, libXmu
, libXrandr
, libXrender
, libXt
, libXxf86vm
, xorgproto
  # darwin
, Cocoa
  # optional
, withNvidiaCg ? false
, nvidia_cg_toolkit
, withSamples ? false
}:

stdenv.mkDerivation rec {
  pname = "ogre";
  version = "13.5.3";

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = "ogre";
    rev = "v${version}";
    sha256 = "sha256-fjgMAuIA7rm3Gt2z//kPkc7LOcfddoFgY38B7bs6zZo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    unzip
  ];

  buildInputs = [
    SDL2
    boost
    freeimage
    freetype
    libpng
    ois
    pugixml
    zziplib
  ] ++ lib.optionals stdenv.isLinux [
    freeglut
    libGL
    libGLU
    libICE
    libSM
    libX11
    libXaw
    libXmu
    libXrandr
    libXrender
    libXt
    libXxf86vm
    xorgproto
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ] ++ lib.optionals withNvidiaCg [
    nvidia_cg_toolkit
  ];

  cmakeFlags = [
    "-DOGRE_BUILD_COMPONENT_OVERLAY_IMGUI=FALSE"
    "-DOGRE_BUILD_DEPENDENCIES=OFF"
    "-DOGRE_BUILD_SAMPLES=${toString withSamples}"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DOGRE_BUILD_LIBS_AS_FRAMEWORKS=FALSE"
  ];

  meta = {
    description = "3D Object-Oriented Graphics Rendering Engine";
    homepage = "https://www.ogre3d.org/";
    maintainers = with lib.maintainers; [ raskin wegank ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
}
