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
    version="0.7.1";
    name="${baseName}-${version}";
    url="http://downloads.xiph.org/releases/${baseName}/${name}.tar.gz";
    hash="93f0e2dfb59021b19e69dc0dee855eb89f19397db1dea0d0d6f9329cff933066";
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
    license = a.lib.licenses.free;
    branch = "0.7";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.celt-codec.org/downloads/";
    };
  };
}) x
