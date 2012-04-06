{ fetchurl, stdenv
, cmake, mesa
, freetype, freeimage, zziplib, randrproto, libXrandr
, libXaw, freeglut, libXt, libpng, boost, ois
, xproto, libX11, libXmu, libSM, pkgconfig
, libXxf86vm, xf86vidmodeproto, libICE
, renderproto, libXrender
, nvidia_cg_toolkit }:

stdenv.mkDerivation {
  name = "ogre-1.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/ogre/1.7/ogre_src_v1-7-2.tar.bz2";
    sha256 = "10q8jx842s4aws9py6q67rb4dh5vli5vvg54jl8manjb4f388jh5";
  };

  cmakeFlags =
    (map (x: "-DOGRE_BUILD_PLUGIN_${x}=on") [ "BSP" "CG" "OCTREE" "PCZ" "PFX" ])
    ++ (map (x: "-DOGRE_BUILD_RENDERSYSTEM_${x}=on") [ "GL" ]);

  enableParallelBuilding = true;

  buildInputs =
   [ cmake mesa
     freetype freeimage zziplib randrproto libXrandr
     libXaw freeglut libXt libpng boost ois
     xproto libX11 libXmu libSM pkgconfig
     libXxf86vm xf86vidmodeproto libICE
     renderproto libXrender
     nvidia_cg_toolkit
   ];

  meta = {
    description = "A 3D engine";
    homepage = http://www.ogre3d.org/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    license = "MIT";
  };
}
