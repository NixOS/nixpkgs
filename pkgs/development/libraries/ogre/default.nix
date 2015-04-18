{ fetchhg, stdenv
, cmake, mesa
, freetype, freeimage, zziplib, randrproto, libXrandr
, libXaw, freeglut, libXt, libpng, boost, ois
, xproto, libX11, libXmu, libSM, pkgconfig
, libXxf86vm, xf86vidmodeproto, libICE
, renderproto, libXrender
, nvidia_cg_toolkit }:

stdenv.mkDerivation {
  name = "ogre-1.9.0";

  src = fetchhg {
    url = "https://bitbucket.org/sinbad/ogre/src/";
    rev = "v1-9-0";
    sha256 = "06hnf4c2kpycm3mglwdyywvj931k8ym808c15xighpyd8h9j4xdi";
  };

  cmakeFlags = [ "-DOGRE_INSTALL_SAMPLES=yes" ]
    ++ (map (x: "-DOGRE_BUILD_PLUGIN_${x}=on")
            [ "BSP" "CG" "OCTREE" "PCZ" "PFX" ])
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
    license = stdenv.lib.licenses.mit;
  };
}
