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
    version = "1.002";
    name="anonymousPro";
    url="http://www.ms-studio.com/FontSales/AnonymousPro-${version}.zip";
    sha256 = "1asj6lykvxh46czbal7ymy2k861zlcdqpz8x3s5bbpqwlm3mhrl6";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.sha256;
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
    license = with a.lib.licenses; ofl;
    hydraPlatforms = [];
    homepage = "http://www.marksimonson.com/fonts/view/anonymous-pro";
    downloadPage = "http://www.ms-studio.com/FontSales/anonymouspro.html";
    inherit (sourceInfo) version;
  };
}) x

