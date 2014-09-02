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
    version = "0.7.0";
    baseName="cm-unicode";
    name="${baseName}-${version}";
    url="mirror://sourceforge/${baseName}/${baseName}/${version}/${name}-otf.tar.xz";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = "0a0w9qm9g8qz2xh3lr61bj1ymqslqsvk4w2ybc3v2qa89nz7x2jl";
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
    downloadPage = "http://sourceforge.net/projects/cm-unicode/files/cm-unicode/";
    inherit version;
  };
}) x

