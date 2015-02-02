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
in
rec {

  src = a.fetchurl {
    url = "https://gist.github.com/arjuncomar/ea303e82bf0c4686f74e/raw/d90f594e7db2a3d4010bdea7d7611a195b87e961/inconsolata-dz-for-powerline.otf";
    sha256 = "3602d6478952d9462c1d9e3060464c0f3458972212c0d3fc4205d7a364b3e77a";
  };

  name = "Inconsolata-dz-For-Powerline";
  inherit buildInputs;

  phaseNames = ["copySrc" "installFonts"];
  
  copySrc = a.fullDepEntry(''
    cp "${src}" inconsolata-dz-for-powerline.otf
  '') ["minInit"];

  meta = {
    description = "A monospace font for both screen and print with powerline glyphs.";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      all;
  };

}) x

