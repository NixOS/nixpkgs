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
    version="2.2";
    baseName="oldstandard";
    name="${baseName}-${version}";
    url="http://www.thessalonica.org.ru/downloads/${name}.otf.zip";
    hash="0xhbksrh9mv1cs6dl2mc8l6sypialy9wirkjr54nf7s9bcynv1h6";
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

