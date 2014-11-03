x@{builderDefsPackage
  , unzip, cmake, mesa, freeglut, libX11, xproto
  , inputproto, libXi, fetchsvn, pkgconfig
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
in
rec {
  version = "2.3.0";
  name = "box2d-${version}";
  srcDrv = a.fetchsvn {
    url = "http://box2d.googlecode.com/svn/trunk";
    rev = "277";
    sha256 = "1xp93yw2zcqhmh999v7cwqaqxq1glgyg5r8kfm4yabc1ypba3in4";
  };
  src = srcDrv + "/";

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
    inherit version;
  };
}) x

