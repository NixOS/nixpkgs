{ lib
, stdenv
, fetchurl
, fetchpatch
, cmake
, pkg-config
, boost
, freeimage
, freetype
, libpng
, ois
, zziplib
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
, darwin
, withNvidiaCg ? false
, nvidia_cg_toolkit
, withSamples ? false
}:

let
  inherit (darwin.apple_sdk.frameworks) AGL Cocoa;
in
stdenv.mkDerivation rec {
  pname = "ogre";
  version = "1.10.11";

  src = fetchurl {
    url = "https://bitbucket.org/sinbad/ogre/get/v${lib.replaceStrings ["."] ["-"] version}.tar.gz";
    sha256 = "1zwvlx5dz9nwjazhnrhzb0w8ilpa84r0hrxrmmy69pgr1p1yif5a";
  };

  patches = [
    # aarch64-darwin support
    (fetchpatch {
      url = "https://github.com/OGRECave/ogre/commit/bd5fbe3482c56e58c6c3b3bf439b1eab8c1be258.patch";
      includes = [ "OgreMain/include/OgrePlatform*.h" ];
      sha256 = "sha256-ELeCklQkltz7DeDaGl78Jk1H3Wdfu8fMUiMZaJM4s/Y=";
    })
    (fetchpatch {
      url = "https://github.com/OGRECave/ogre/commit/0873244cc06b613ca2afbcb5522fe9ef89f111c5.patch";
      sha256 = "sha256-xGvlMB55B2rdthxNMIM5iFf9p/6zuE8bGL9P04qtweQ=";
    })
    # aarch64-linux support
    (fetchpatch {
      name = "fix-build-on-aarch64-linux.patch";
      url = "https://github.com/OGRECave/ogre/commit/8ec086e9bc2e24fab373b514c572483b69071d69.patch";
      sha256 = "sha256-22wlJPZ7lRIPAMqvpI/2YI0neQjGi1UXt8y5zNSpxCw=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
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
    "-DOGRE_BUILD_COMPONENT_OVERLAY_IMGUI=FALSE"
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
