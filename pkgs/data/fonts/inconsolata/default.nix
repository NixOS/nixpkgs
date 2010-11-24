x@{builderDefsPackage
  , fontforge
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    name="inconsolata";
    url="http://www.levien.com/type/myfonts/Inconsolata.sfd";
    hash="1cd29c8396adb18bfeddb1abf5bdb98b677649bb9b09f126d1335b123a4cfddb";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["copySrc" "generateFontsFromSFD" "installFonts"];
  
  copySrc = a.fullDepEntry (''
    cp ${src} inconsolata.sfd
  '') ["minInit"];

  generateFontsFromSFD = a.generateFontsFromSFD // {deps=["addInputs"];};

  meta = {
    description = "A monospace font for both screen and print";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      all;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.levien.com/type/myfonts/inconsolata.html";
    };
  };
}) x

