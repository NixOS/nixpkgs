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
    version="0.11.1";
    name="${baseName}-${version}";
    url="http://downloads.xiph.org/releases/${baseName}/${name}.tar.gz";
    hash="1gsc3pxydyzzra8w0r6hrrsalm76lrq4lw6bd283qa4bpagmghh1";
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

