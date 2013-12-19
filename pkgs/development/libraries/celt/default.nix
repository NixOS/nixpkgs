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
    baseName="celt";
    version="0.11.3";
    name="${baseName}-${version}";
    url="http://downloads.xiph.org/releases/${baseName}/${name}.tar.gz";
    hash="0dh893wqbh0q4a0x1xyqryykmnhpv7mkblpch019s04a99fq2r3y";
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
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "CELT - low-delay audio codec";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "free";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.celt-codec.org/downloads/";
    };
  };
}) x

