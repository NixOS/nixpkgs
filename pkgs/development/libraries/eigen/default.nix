x@{builderDefsPackage
  , cmake
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="eigen";
    version="2.0.15";
    name="${baseName}-${version}";
    ext="tar.bz2";
    project="${baseName}";
    url="http://bitbucket.org/${project}/${baseName}/get/${version}.${ext}";
    hash="c68509b80ec2570d025a98e6c4279062b801593c5165ba3d683852e7dbff1569";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
    name="${sourceInfo.name}.${sourceInfo.ext}";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["doCmake" "doMakeInstall"];
      
  meta = {
    description = "A C++ linear algebra template header";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.lgpl3Plus;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://eigen.tuxfamily.org/index.php?title=Main_Page";
    };
  };
}) x
