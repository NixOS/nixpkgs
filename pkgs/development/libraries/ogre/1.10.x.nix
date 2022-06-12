{ fetchurl, stdenv, lib
, cmake, libGLU, libGL
, freetype, freeimage, zziplib, xorgproto, libXrandr
, libXaw, freeglut, libXt, libpng, boost, ois
, libX11, libXmu, libSM, pkg-config
, libXxf86vm, libICE
, libXrender
, withNvidiaCg ? false, nvidia_cg_toolkit
, withSamples ? false }:

stdenv.mkDerivation rec {
  pname = "ogre";
  version = "1.10.11";

  src = fetchurl {
     url = "https://bitbucket.org/sinbad/ogre/get/v${lib.replaceStrings ["."] ["-"] version}.tar.gz";
     sha256 = "1zwvlx5dz9nwjazhnrhzb0w8ilpa84r0hrxrmmy69pgr1p1yif5a";
  };

  # fix for ARM. sys/sysctl.h has moved in later glibcs, and
  # https://github.com/OGRECave/ogre-next/issues/132 suggests it isn't
  # needed anyway.
  postPatch = ''
    substituteInPlace OgreMain/src/OgrePlatformInformation.cpp \
      --replace '#include <sys/sysctl.h>' ""
  '';

  cmakeFlags = [ "-DOGRE_BUILD_SAMPLES=${toString withSamples}" ]
    ++ map (x: "-DOGRE_BUILD_PLUGIN_${x}=on")
           ([ "BSP" "OCTREE" "PCZ" "PFX" ] ++ lib.optional withNvidiaCg "CG")
    ++ map (x: "-DOGRE_BUILD_RENDERSYSTEM_${x}=on") [ "GL" ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs =
   [ libGLU libGL
     freetype freeimage zziplib xorgproto libXrandr
     libXaw freeglut libXt libpng boost ois
     libX11 libXmu libSM
     libXxf86vm libICE
     libXrender
   ] ++ lib.optional withNvidiaCg nvidia_cg_toolkit;

  meta = {
    description = "A 3D engine";
    homepage = "https://www.ogre3d.org/";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
