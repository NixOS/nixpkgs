{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  unzip,
  SDL2,
  boost,
  freetype,
  libpng,
  ois,
  pugixml,
  zziplib,
  rapidjson,
  xcbutil,
  # linux
  libglut,
  libGL,
  libGLU,
  libICE,
  libSM,
  libX11,
  libXaw,
  libXmu,
  libXrandr,
  libXrender,
  libXt,
  libXxf86vm,
  xorgproto,
  # optional
  withNvidiaCg ? false,
  nvidia_cg_toolkit,
  withSamples ? false,
}:

let
  common =
    {
      version,
      hash,
      imguiVersion,
      imguiHash,
    }:
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
        repo = "ogre-next";
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
        rapidjson
        xcbutil
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
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
      ]
      ++ lib.optionals withNvidiaCg [
        nvidia_cg_toolkit
      ];

      cmakeFlags = [
        (lib.cmakeBool "OGRE_BUILD_DEPENDENCIES" false)
        (lib.cmakeBool "OGRE_BUILD_SAMPLES" withSamples)
        "-DOGRE_CONFIG_ENABLE_STBI=ON"
        "-DOGRE_CONFIG_ENABLE_FREEIMAGE=OFF"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        (lib.cmakeBool "OGRE_BUILD_LIBS_AS_FRAMEWORKS" false)
      ];

      meta = {
        description = "3D Object-Oriented Graphics Rendering Engine";
        homepage = "https://www.ogre3d.org/";
        maintainers = with lib.maintainers; [
          raskin
          wegank
        ];
        platforms = lib.platforms.unix;
        license = lib.licenses.mit;
      };
    };
in
{
  ogre-next_3 = common {
    version = "3.0.0";
    hash = "sha256-nJkCGKl9+6gApVtqk5OZjTOJllAJIiBKuquTYvR4NPs=";
    imguiVersion = "1.91.9b";
    imguiHash = "sha256-dkukDP0HD8CHC2ds0kmqy7KiGIh4148hMCyA1QF3IMo=";
  };
}
