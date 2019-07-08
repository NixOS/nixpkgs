{ fetchurl, stdenv, lib
, cmake, libGLU_combined
, freetype, freeimage, zziplib, xorgproto, libXrandr
, libXaw, freeglut, libXt, libpng, boost, ois
, libX11, libXmu, libSM, pkgconfig
, libXxf86vm, libICE
, libXrender
, withNvidiaCg ? false, nvidia_cg_toolkit
, withSamples ? false }:

stdenv.mkDerivation {
  name = "ogre-1.10.11";

  src = fetchurl {
     url = "https://bitbucket.org/sinbad/ogre/get/v1-10-11.tar.gz";
     sha256 = "1zwvlx5dz9nwjazhnrhzb0w8ilpa84r0hrxrmmy69pgr1p1yif5a";
  };

  cmakeFlags = [ "-DOGRE_BUILD_SAMPLES=${toString withSamples}" ]
    ++ map (x: "-DOGRE_BUILD_PLUGIN_${x}=on")
           ([ "BSP" "OCTREE" "PCZ" "PFX" ] ++ lib.optional withNvidiaCg "CG")
    ++ map (x: "-DOGRE_BUILD_RENDERSYSTEM_${x}=on") [ "GL" ];

  enableParallelBuilding = true;

  buildInputs =
   [ cmake libGLU_combined
     freetype freeimage zziplib xorgproto libXrandr
     libXaw freeglut libXt libpng boost ois
     libX11 libXmu libSM pkgconfig
     libXxf86vm libICE
     libXrender
   ] ++ lib.optional withNvidiaCg nvidia_cg_toolkit;

  meta = {
    description = "A 3D engine";
    homepage = https://www.ogre3d.org/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
  };
}
