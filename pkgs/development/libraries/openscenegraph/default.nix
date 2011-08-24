x@{builderDefsPackage
  , cmake, giflib, libjpeg, libtiff, lib3ds, freetype, libpng
  , coin3d, jasper, gdal, xproto, libX11, libXmu, freeglut, mesa
  , doxygen, ffmpeg, xineLib, unzip, zlib, openal, libxml2
  , curl
  , ...}:
builderDefsPackage
(a :
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="OpenSceneGraph";
    version="2.8.3";
    name="${baseName}-${version}";
    url="http://www.openscenegraph.org/downloads/stable_releases/${name}/source/${name}.zip";
    hash="0phihxs7zgir9n1z54xsrsha8wa0xll7xl6lvqvrrczf0bm80yrs";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "addInputs" "doUnpack" "doCmake" "doMakeInstall"];

  cmakeFlags = [
    "-D MATH_LIBRARY="
  ];

  setVars = a.noDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D__STDC_CONSTANT_MACROS=1"
  '';
      
  meta = {
    description = "A 3D graphics toolkit";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "OpenSceneGraph Public License - free LGPL-based license";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.openscenegraph.org/projects/osg/wiki/Downloads";
    };
  };
}) x

