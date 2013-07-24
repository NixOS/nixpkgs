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
    version="1.4.4";
    name="${baseName}-${version}";
    url="mirror://sourceforge/${baseName}/${name}.tgz";
    hash="057k191hx7sf84wdvc8wr1nk4whhrvbg1vv3r4nyswjir6qwphnr";
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

