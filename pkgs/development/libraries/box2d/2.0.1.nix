x@{builderDefsPackage
  , unzip, cmake, mesa, freeglut, libX11, xproto
  , inputproto, libXi
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="box2d";
    version="2.0.1";
    name="${baseName}-${version}";
    url="http://box2d.googlecode.com/files/Box2D_v${version}.zip";
    hash="62857048aa089b558561074154430883cee491eedd71247f75f488cba859e21f";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["fixIncludes" "setVars" "changeSettings" "doMake" "doDeploy"];

  goSrcDir = ''cd Box2D'';

  fixIncludes = a.fullDepEntry ''
    sed -i Source/Dynamics/Contacts/b2PolyContact.cpp \
        -i Source/Dynamics/Contacts/b2CircleContact.cpp \
        -i Source/Dynamics/Contacts/b2PolyAndCircleContact.cpp \
        -i Source/Common/b2BlockAllocator.cpp \
        -i Source/Collision/b2BroadPhase.cpp \
        -i Examples/TestBed/Framework/Render.cpp \
        -i Examples/TestBed/Tests/BroadPhaseTest.cpp \
        -i Examples/TestBed/Tests/TestEntries.cpp \
        -e '1i#include <string.h>'
  '' ["minInit" "addInputs" "doUnpack"];

  setVars = a.noDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lX11 -lXi"
  '';

  doDeploy = a.fullDepEntry ''
    mkdir -p "$out"/lib
    mkdir -p "$out"/include/Box2D
    cp Library/* Source/Gen/float/lib*.{a,so} "$out"/lib
    cp -r Source "$out"/include/Box2D/Source
    find "$out"/include/Box2D/Source ! -name '*.h' -exec rm '{}' ';'
    sed -e s@../Source@Box2D/Source@ -i Include/Box2D.h
    cp Include/Box2D.h "$out"/include/Box2D
    mkdir -p "$out/share"
    cp -r Examples "$out/share"
  '' ["minInit" "addInputs" "doMake" "defEnsureDir"];

  changeSettings = a.fullDepEntry ''
    sed -i Source/Common/b2Settings.h -e 's@b2_maxPolygonVertices .*@b2_maxPolygonVertices = 15;@'
  '' ["minInit" "addInputs" "doUnpack"];
      
  meta = {
    description = "2D physics engine";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "bsd";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://code.google.com/p/box2d/downloads/list";
    };
  };
}) x

