{ fetchFromGitHub, stdenv, lib
, cmake, libGLU_combined
, freetype, freeimage, zziplib, xorgproto, libXrandr
, libXaw, freeglut, libXt, libpng, boost, ois
, libX11, libXmu, libSM, pkgconfig
, libXxf86vm, libICE
, libXrender
, withNvidiaCg ? false, nvidia_cg_toolkit
, withSamples ? false }:

stdenv.mkDerivation rec {
  pname = "ogre";
  version = "1.9.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = "ogre";
    rev = "v${version}";
    sha256 = "11lfgzqaps3728dswrq3cbwk7aicigyz08q4hfyy6ikc6m35r4wg";
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
