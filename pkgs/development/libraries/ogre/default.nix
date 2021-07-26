{ fetchFromGitHub, stdenv, lib
, cmake, libGLU, libGL
, freetype, freeimage, zziplib, xorgproto, libXrandr
, libXaw, freeglut, libXt, libpng, boost, ois
, libX11, libXmu, libSM, pkg-config
, libXxf86vm, libICE
, unzip
, libXrender
, SDL2
, pugixml
, withNvidiaCg ? false, nvidia_cg_toolkit
, withSamples ? false
, withImgui ? false
}:

let
  imgui = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = "v1.79";
    sha256 = "GIVhZ8Q7WebfHeKeJdVABXrTT26FOS7updncbv2LRnQ=";
  };

in stdenv.mkDerivation rec {
  pname = "ogre";
  version = "1.12.12";

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = pname;
    rev = "v${version}";
    sha256 = "1OyqOUaAxuHEE23Fu/Ngd06+IbPFaCQIMceirBOk/6c=";
  };

  preConfigure = lib.optionalString withImgui ''
    mkdir build
    cp -r ${imgui} build/imgui-1.79
    chmod u+w -R build
  '';

  cmakeFlags = [ "-DOGRE_BUILD_DEPENDENCIES=OFF" "-DOGRE_BUILD_SAMPLES=${toString withSamples}"
                  ]
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
     pugixml
   ] ++ lib.optional withNvidiaCg nvidia_cg_toolkit;

  meta = {
    description = "A 3D engine";
    homepage = "https://www.ogre3d.org/";
    maintainers = [ lib.maintainers.raskin lib.maintainers.luc65r ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
