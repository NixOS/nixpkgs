x@{builderDefsPackage
  , cmake, giflib, libjpeg, libtiff, lib3ds, freetype, libpng
  , coin3d, jasper, gdal, xproto, libX11, libXmu, freeglut, mesa
  , doxygen, ffmpeg, xineLib, unzip, zlib, openal, libxml2
  , curl, a52dec, faad2, gdk_pixbuf, pkgconfig, kbproto, SDL
  , qt4, poppler, librsvg, gtk
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
    version="3.2.1";
    name="${baseName}-${version}";
    url="http://www.openscenegraph.org/downloads/developer_releases/${name}.zip";
    hash="0v9y1gxb16y0mj994jd0mhcz32flhv2r6kc01xdqb4817lk75bnr";
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
  phaseNames = ["setVars" "addInputs" "doUnpack" "doPatch" "doCmake" "doMakeInstall"];

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

