{ fetchurl, stdenv, lib
, cmake, libGLU, libGL
, freetype, freeimage, zziplib, xorgproto, libXrandr
, libXaw, freeglut, libXt, libpng, boost, ois
, libX11, libXmu, libSM, pkg-config
, libXxf86vm, libICE
, unzip
, libXrender
, SDL2
, withNvidiaCg ? false, nvidia_cg_toolkit
, withSamples ? false }:

stdenv.mkDerivation rec {
  pname = "ogre";
  version = "1.12.1";

  src = fetchurl {
     url = "https://github.com/OGRECave/ogre/archive/v${version}.zip";
     sha256 = "1iv6k0dwdzg5nnzw2mcgcl663q4f7p2kj7nhs8afnsikrzxxgsi4";
  };

  cmakeFlags = [ "-DOGRE_BUILD_DEPENDENCIES=OFF" "-DOGRE_BUILD_SAMPLES=${toString withSamples}" ]
    ++ map (x: "-DOGRE_BUILD_PLUGIN_${x}=on")
           ([ "BSP" "OCTREE" "PCZ" "PFX" ] ++ lib.optional withNvidiaCg "CG")
    ++ map (x: "-DOGRE_BUILD_RENDERSYSTEM_${x}=on") [ "GL" ];


  nativeBuildInputs = [ cmake unzip pkg-config ];
  buildInputs =
   [ cmake libGLU libGL
     freetype freeimage zziplib xorgproto libXrandr
     libXaw freeglut libXt libpng boost ois
     libX11 libXmu libSM
     libXxf86vm libICE
     libXrender
     SDL2
   ] ++ lib.optional withNvidiaCg nvidia_cg_toolkit;

  meta = {
    description = "A 3D engine";
    homepage = "https://www.ogre3d.org/";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
