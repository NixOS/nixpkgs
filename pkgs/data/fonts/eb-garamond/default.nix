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
    version="0.016";
    name="EBGaramond";
    url="https://bitbucket.org/georgd/eb-garamond/downloads/${name}-${version}.zip";
    hash="0y630khn5zh70al3mm84fs767ac94ffyz1w70zzhrhambx07pdx0";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  name = "eb-garamond-${sourceInfo.version}";
  inherit buildInputs;

  phaseNames = ["doUnpack" "installFonts"];

  # This will clean up if/when 8263996 lands.
  doUnpack = a.fullDepEntry (''
    unzip ${src}
    cd ${sourceInfo.name}*
    mv {ttf,otf}/* .
  '') ["addInputs"];

  meta = with a.lib; {
    description = "Digitization of the Garamond shown on the Egenolff-Berner specimen";
    maintainers = with maintainers; [ relrod ];
    platforms = platforms.all;
    license = licenses.ofl;
    homepage = http://www.georgduffner.at/ebgaramond/;
  };
  passthru = {
    updateInfo = {
      downloadPage = "https://github.com/georgd/EB-Garamond/releases";
    };
  };
}) x

