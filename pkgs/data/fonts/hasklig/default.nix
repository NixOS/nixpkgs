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
    version="0.4";
    name="Hasklig";
    url="https://github.com/i-tu/Hasklig/releases/download/${version}/Hasklig-${version}.zip";
    hash="14j0zfapw6s6x5psp1rvx2i59rxdwb1jgwfgfhzhypr22qy40xi8";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  name = "hasklig-${sourceInfo.version}";
  inherit buildInputs;

  phaseNames = ["doUnpack" "installFonts"];

  doUnpack = a.fullDepEntry (''
    unzip ${src}
    # cd ${sourceInfo.name}*/OTF/
  '') ["addInputs"];

  meta = {
    description = "A font with ligatures for Haskell code based off Source Code Pro";
    maintainers = [ a.lib.maintainers.davidrusu ];
    platforms = with a.lib.platforms; all;
    homepage = "https://github.com/i-tu/Hasklig";
    license = "OFL";
  };
}) x
