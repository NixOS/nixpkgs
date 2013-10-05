x@{builderDefsPackage
  , unzip
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    version="1.002";
    name="anonymousPro";
    url="http://www.ms-studio.com/FontSales/AnonymousPro-${version}.zip";
    hash="86665847a51cdfb58a1e1dfd8b1ba33f183485affe50b53e3304f63d3d3552ab";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  name = "${sourceInfo.name}-${sourceInfo.version}";
  inherit buildInputs;

  phaseNames = ["doUnpack" "installFonts"];

  doUnpack = a.fullDepEntry (''
    unzip ${src}
    cd AnonymousPro*/
  '') ["addInputs"];
      
  meta = {
    description = "TrueType font set intended for source code";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      all;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.ms-studio.com/FontSales/anonymouspro.html";
    };
  };
}) x

