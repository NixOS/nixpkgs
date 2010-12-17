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
    version="2.1.2";
    name="${baseName}-${version}";
    url="http://box2d.googlecode.com/files/Box2D_v${version}.zip";
    hash="0m5szd74ig8yqazwk2g3zl4z7wwp08k52awawk1pigy6a4z1qd9v";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["changeSettings" "doCmake" "doMakeInstall"];

  changeSettings = a.fullDepEntry ''
    sed -i Box2D/Common/b2Settings.h -e 's@b2_maxPolygonVertices .*@b2_maxPolygonVertices 15@'
  '' ["minInit" "addInputs" "doUnpack"];
      
  goSrcDir = ''cd Box2D'';

  doCmake = a.fullDepEntry ''
    cd Build; 
    cmake -DBOX2D_INSTALL=ON -DBOX2D_BUILD_SHARED=ON -DCMAKE_INSTALL_PREFIX=$out ..
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

