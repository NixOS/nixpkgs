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
    version="1.504";
    baseName="GentiumPlus";
    name="${baseName}-${version}";
    url="http://scripts.sil.org/cms/scripts/render_download.php?&format=file&media_id=${name}.zip&filename=${name}";
    hash="04kslaqbscpfrc6igkifcv1nkrclrm35hqpapjhw9102wpq12fpr";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
    name = "${sourceInfo.name}.zip";
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["addInputs" "doUnpack" "installFonts"];

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
      downloadPage = "http://scripts.sil.org/cms/scripts/page.php?item_id=Gentium_download";
    };
  };
}) x

