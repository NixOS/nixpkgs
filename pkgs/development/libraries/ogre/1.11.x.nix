{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, unzip
, boost
, freeimage
, freetype
, libpng
, ois
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
, AGL
, Cocoa
  # optional
, withNvidiaCg ? false
, nvidia_cg_toolkit
, withSamples ? false
}:

stdenv.mkDerivation rec {
  pname = "ogre";
  version = "1.11.6";

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = "ogre";
    rev = "v${version}";
    sha256 = "sha256-lCRa3sloF0o7Wz8QAuPyJTXYrvNmAfuKsz/DzjgSyls=";
  };

  # Fix for ARM.
  patches = [
    (fetchpatch {
      url = "https://github.com/OGRECave/ogre/commit/8ec086e9bc2e24fab373b514c572483b69071d69.patch";
      sha256 = "sha256-22wlJPZ7lRIPAMqvpI/2YI0neQjGi1UXt8y5zNSpxCw=";
    })
    (fetchpatch {
      url = "https://github.com/OGRECave/ogre/commit/0873244cc06b613ca2afbcb5522fe9ef89f111c5.patch";
      sha256 = "sha256-xGvlMB55B2rdthxNMIM5iFf9p/6zuE8bGL9P04qtweQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    unzip
  ];

  buildInputs = [
    boost
    freeimage
    freetype
    libpng
    ois
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
    AGL
    Cocoa
  ] ++ lib.optionals withNvidiaCg [
    nvidia_cg_toolkit
  ];

  cmakeFlags = [
    "-DOGRE_BUILD_SAMPLES=${toString withSamples}"
    "-DOGRE_RESOURCEMANAGER_STRICT=0"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DOGRE_BUILD_LIBS_AS_FRAMEWORKS=FALSE"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    "-DCMAKE_OSX_ARCHITECTURES=arm64"
  ];

  meta = {
    description = "3D Object-Oriented Graphics Rendering Engine";
    homepage = "https://www.ogre3d.org/";
    maintainers = with lib.maintainers; [ raskin wegank ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
}
