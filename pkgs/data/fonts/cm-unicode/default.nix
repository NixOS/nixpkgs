x@{builderDefsPackage
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    version="0.6.3a";
    baseName="cm-unicode";
    name="${baseName}-${version}";
    url="ftp://canopus.iacp.dvo.ru/pub/Font/cm_unicode/${name}-otf.tar.gz";
    hash="1018gmvh7wl7sm6f3fqd917syd1yy0gz3pxmrc9lkxckcr7wz0zp";
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
      downloadPage = "http://canopus.iacp.dvo.ru/~panov/cm-unicode/download.html";
    };
  };
}) x

