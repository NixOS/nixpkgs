{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, unzip
, SDL2
, boost
, freetype
, libpng
, ois
, pugixml
, zziplib
  # linux
, libglut
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
  common = { version, hash, imguiVersion, imguiHash }:
  let
    imgui.src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      rev = "v${imguiVersion}";
      hash = imguiHash;
    };
  in
  stdenv.mkDerivation {
    pname = "ogre";
    inherit version;

    src = fetchFromGitHub {
      owner = "OGRECave";
      repo = "ogre";
      rev = "v${version}";
      inherit hash;
    };

    postPatch = ''
      mkdir -p build
      cp -R ${imgui.src} build/imgui-${imguiVersion}
      chmod -R u+w build/imgui-${imguiVersion}
    '';

    nativeBuildInputs = [
      cmake
      pkg-config
      unzip
    ];

    buildInputs = [
      SDL2
      boost
      freetype
      libpng
      ois
      pugixml
      zziplib
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [
      libglut
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
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Cocoa
    ] ++ lib.optionals withNvidiaCg [
      nvidia_cg_toolkit
    ];

    cmakeFlags = [
      (lib.cmakeBool "OGRE_BUILD_DEPENDENCIES" false)
      (lib.cmakeBool "OGRE_BUILD_SAMPLES" withSamples)
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (lib.cmakeBool "OGRE_BUILD_LIBS_AS_FRAMEWORKS" false)
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
    version = "14.3.2";
    hash = "sha256-MOTEI0OyGVCH1CVK/pH51r9QkrGspLC3sBIROYHklyk=";
    # https://github.com/OGRECave/ogre/blob/v14.3.2/Components/Overlay/CMakeLists.txt
    imguiVersion = "1.91.2";
    imguiHash = "sha256-B7XXQNuEPcT1ID5nMYbAV+aNCG9gIrC9J7BLnYB8yjI=";
  };

  ogre_13 = common {
    version = "13.6.5";
    hash = "sha256-8VQqePrvf/fleHijVIqWWfwOusGjVR40IIJ13o+HwaE=";
    # https://github.com/OGRECave/ogre/blob/v13.6.5/Components/Overlay/CMakeLists.txt
    imguiVersion = "1.87";
    imguiHash = "sha256-H5rqXZFw+2PfVMsYvAK+K+pxxI8HnUC0GlPhooWgEYM=";
  };
}
