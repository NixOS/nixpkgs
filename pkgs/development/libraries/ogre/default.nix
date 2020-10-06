{ fetchFromGitHub
, stdenv
, lib
, cmake
, libGLU
, libGL
, freetype
, freeimage
, zziplib
, xorgproto
, libXrandr
, libXaw
, freeglut
, libXt
, libpng
, boost
, ois
, libX11
, libXmu
, libSM
, pkg-config
, libXxf86vm
, libICE
, unzip
, libXrender
, SDL2
, pugixml
, writeScriptBin
, rsync
, Foundation
, AppKit
, AGL
, Cocoa
, libobjc
, withNvidiaCg ? false
, nvidia_cg_toolkit
, withSamples ? false
}:

let
  ditto = writeScriptBin "ditto"''
    #!${stdenv.shell}
    ${rsync}/bin/rsync "$@"
  '';
in

stdenv.mkDerivation rec {
  pname = "ogre";
  version = "1.12.9";

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = "ogre";
    rev = "v${version}";
    sha256 = "sha256-uv61SuZzmBZKConOHYKEv9/QHWUcS6MmdHl6GwbkFyw=";
  };

  # fix for ARM. sys/sysctl.h has moved in later glibcs, and
  # https://github.com/OGRECave/ogre-next/issues/132 suggests it isn't
  # needed anyway.
  postPatch = ''
    substituteInPlace OgreMain/src/OgrePlatformInformation.cpp \
      --replace '#include <sys/sysctl.h>' ""
  '';

  cmakeFlags = [ "-DOGRE_BUILD_DEPENDENCIES=OFF" "-DOGRE_BUILD_SAMPLES=${toString withSamples}" ]
    ++ map (x: "-DOGRE_BUILD_PLUGIN_${x}=on")
    ([ "BSP" "OCTREE" "PCZ" "PFX" ] ++ lib.optional withNvidiaCg "CG")
    ++ map (x: "-DOGRE_BUILD_RENDERSYSTEM_${x}=on") [ "GL" ]
    ++ lib.optionals stdenv.isDarwin [ "-DOGRE_ENABLE_PRECOMPILED_HEADERS=false" ];

  nativeBuildInputs = [ cmake unzip pkg-config ];
  buildInputs = [
      libGLU
      libGL
      freetype
      freeimage
      zziplib
      xorgproto
      libXrandr
      libXaw
      freeglut
      libXt
      libpng
      boost
      ois
      libX11
      libXmu
      libSM
      libXxf86vm
      libICE
      libXrender
      SDL2
      pugixml
  ] ++ lib.optional withNvidiaCg nvidia_cg_toolkit
    ++ lib.optionals stdenv.isDarwin [
      libobjc
      Foundation
      AppKit
      Cocoa
      AGL
      ditto
  ];

  meta = {
    description = "A 3D engine";
    homepage = "https://www.ogre3d.org/";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
}
