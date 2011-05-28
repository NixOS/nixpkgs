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
    version="0.2";
    baseName="tempora-lgc";
    name="${baseName}-${version}";
    url="http://www.thessalonica.org.ru/downloads/${baseName}.otf.zip";
    hash="18n5ml2chc1bhrv43i64sz2dz1zc2dw087wcwn5l9ysqsmf0387i";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["doUnpack" "installFonts"];

  doUnpack = a.fullDepEntry ''
    unzip ${src}
  '' ["addInputs"];
      
  meta = {
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      all;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.thessalonica.org.ru/ru/fonts-download.html";
    };
  };
}) x

