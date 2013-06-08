x@{builderDefsPackage
  , autoconf, automake, libtool, doxygen, procps
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="srtp";
    version="1.4.2";
    name="${baseName}-${version}";
    url="http://srtp.sourceforge.net/${name}.tgz";
    hash="1497mcxharnhiccjhny30g4wlv28ckdxhj14jrwvdnnvhl80jf43";
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
  phaseNames = ["setVars" "doConfigure" "doMakeInstall"];

  setVars = a.fullDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fPIC"
  '' ["minInit"];

  meta = {
    description = "Secure RTP";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://srtp.sourceforge.net/download.html";
    };
  };
}) x

