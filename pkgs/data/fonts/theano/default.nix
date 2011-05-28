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
    version="2.0";
    baseName="theano";
    name="${baseName}-${version}";
    url="http://www.thessalonica.org.ru/downloads/${name}.otf.zip";
    hash="1xiykqbbiawvfk33639awmgdn25b8s2k7vpwncl17bzlk887b4z6";
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
    description = "An old-style font";
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

