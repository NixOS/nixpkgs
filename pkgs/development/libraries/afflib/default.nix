x@{builderDefsPackage
  , libewf, zlib, curl, expat, fuse, openssl
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="afflib";
    version="3.6.12";
    name="${baseName}-${version}";
    url="http://afflib.org/downloads/${name}.tar.gz";
    hash="1l13nrqjlvad112543qbyvrzai5by43zl96d3miklrhn26q9rs07";
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
    description = "Advanced forensic format library";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.bsdOriginal;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://afflib.org/";
    };
  };
}) x

