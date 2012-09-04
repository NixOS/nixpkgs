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
    version="0.5.1.3";
    name="${baseName}-${version}";
    url="http://downloads.xiph.org/releases/${baseName}/${name}.tar.gz";
    hash="0bkam9z5vnrxpbxkkh9kw6yzjka9di56h11iijikdd1f71l5nbpw";
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
