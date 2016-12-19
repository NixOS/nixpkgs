{ fetchurl, stdenv, lib
, cmake, mesa
, freetype, freeimage, zziplib, randrproto, libXrandr
, libXaw, freeglut, libXt, libpng, boost, ois
, xproto, libX11, libXmu, libSM, pkgconfig
, libXxf86vm, xf86vidmodeproto, libICE
, renderproto, libXrender
, withNvidiaCg ? false, nvidia_cg_toolkit
, withSamples ? false }:

stdenv.mkDerivation {
  name = "ogre-1.9-hg-20160322";

  src = fetchurl {
     url = "https://bitbucket.org/sinbad/ogre/get/v1-9.tar.gz";
     sha256 = "0w3argjy1biaxwa3c80zxxgll67wjp8czd83p87awlcvwzdk5mz9";
  };

  cmakeFlags = [ "-DOGRE_BUILD_SAMPLES=${toString withSamples}" ]
    ++ map (x: "-DOGRE_BUILD_PLUGIN_${x}=on")
           ([ "BSP" "OCTREE" "PCZ" "PFX" ] ++ lib.optional withNvidiaCg "CG")
    ++ map (x: "-DOGRE_BUILD_RENDERSYSTEM_${x}=on") [ "GL" ];

  enableParallelBuilding = true;

  buildInputs =
   [ cmake mesa
     freetype freeimage zziplib randrproto libXrandr
     libXaw freeglut libXt libpng boost ois
     xproto libX11 libXmu libSM pkgconfig
     libXxf86vm xf86vidmodeproto libICE
     renderproto libXrender
   ] ++ lib.optional withNvidiaCg nvidia_cg_toolkit;

  meta = {
    description = "A 3D engine";
    homepage = http://www.ogre3d.org/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
  };
}
