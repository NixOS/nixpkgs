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
, darwin
  # optional
, withNvidiaCg ? false
, nvidia_cg_toolkit
, withSamples ? false
}:

let
  common = { version, hash }: stdenv.mkDerivation {
    pname = "ogre";
    inherit version;

    src = fetchFromGitHub {
      owner = "OGRECave";
      repo = "ogre";
      rev = "v${version}";
      inherit hash;
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
      darwin.apple_sdk.frameworks.Cocoa
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
  };
in
{
  ogre_14 = common {
    version = "14.1.2";
    hash = "sha256-qPoC5VXA9IC1xiFLrvE7cqCZFkuiEM0OMowUXDlmhF4=";
  };

  ogre_13 = common {
    version = "13.6.5";
    hash = "sha256-8VQqePrvf/fleHijVIqWWfwOusGjVR40IIJ13o+HwaE=";
  };
}
