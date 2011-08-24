x@{builderDefsPackage
  , plib, freeglut, xproto, libX11, libXext, xextproto, libXi , inputproto
  , libICE, libSM, libXt, libXmu, mesa, boost, zlib, libjpeg , freealut
  , openscenegraph, openal
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="SimGear";
    version="2.0.0";
    name="${baseName}-${version}";
    extension="tar.gz";
    url="ftp://ftp.goflyflightgear.com/simgear/Source/${name}.${extension}";
    hash="08fia5rjrlvw45i3v09fn90vhdhb54wjl6kn3d8vpspxmsw4fn55";
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
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "Simulation construction toolkit";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.lgpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "ftp://ftp.goflyflightgear.com/simgear/Source/";
    };
  };
}) x

