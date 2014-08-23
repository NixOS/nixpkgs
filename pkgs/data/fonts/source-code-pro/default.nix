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
    version="1.017";
    name="SourceCodePro";
    url="mirror://sourceforge/sourcecodepro.adobe/${name}_FontsOnly-${version}.zip";
    hash="07xjfxin883a3g3admdddxxqyzigihbsnmik0zpjii09cdlb8dl1";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  name = "source-code-pro-${sourceInfo.version}";
  inherit buildInputs;

  phaseNames = ["doUnpack" "installFonts"];

  doUnpack = a.fullDepEntry (''
    unzip ${src}
    cd ${sourceInfo.name}*/OTF/
  '') ["addInputs"];

  meta = {
    description = "A set of monospaced OpenType fonts designed for coding environments";
    maintainers = with a.lib.maintainers; [ relrod ];
    platforms = with a.lib.platforms; all;
    homepage = "http://blog.typekit.com/2012/09/24/source-code-pro/";
    license = "OFL";
  };
}) x
