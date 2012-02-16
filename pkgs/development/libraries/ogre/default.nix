x@{builderDefsPackage
  , mesa, cmake, automake, libtool, autoconf
  , freetype, freeimage, zziplib, randrproto, libXrandr
  , libXaw, freeglut, libXt, libpng, boost, ois
  , xproto, libX11, libXmu, libSM, pkgconfig
  , libXxf86vm, xf86vidmodeproto, libICE
  , renderproto, libXrender
  , nvidia_cg_toolkit
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="ogre";
    majorVersion="1";
    minorVersion="7";
    patchLevel="2";
    version="${majorVersion}.${minorVersion}.${patchLevel}";
    name="${baseName}-${version}";
    project="${baseName}";
    url="mirror://sourceforge/project/${project}/${baseName}/${majorVersion}.${minorVersion}/${baseName}_src_v${majorVersion}-${minorVersion}-${patchLevel}.tar.bz2";
    hash="10q8jx842s4aws9py6q67rb4dh5vli5vvg54jl8manjb4f388jh5";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  doMyBuild = a.fullDepEntry ("make -j4") ["doCmake"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doCmake" "doMyBuild" "doMakeInstall"];

  cmakeSkipRpath = false;

  meta = {
    description = "A 3D engine";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "MIT";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.ogre3d.org/download/source";
    };
  };
}) x

