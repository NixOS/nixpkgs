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
    baseName="gsm";
    version="1.0.13";
    name="${baseName}-${version}";
    url="http://www.quut.com/gsm/${name}.tar.gz";
    hash="1bcjl2h60gvr1dc5a963h3vnz9zl6n8qrfa3qmb2x3229lj1iiaj";
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
  phaseNames = ["createDirs" "setVars" "doMakeInstall"];

  createDirs = a.fullDepEntry ''
    mkdir -p "$out/"{bin,lib,share/man,share/info,include/gsm}
  '' ["minInit" "defEnsureDir"];

  setVars = a.noDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fPIC"
  '';

  makeFlags = [
    ''INSTALL_ROOT="$out"''
    ''GSM_INSTALL_INC="$out/include/gsm"''
  ];
      
  meta = {
    description = "A GSM codec library";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "free-noncopyleft";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.quut.com/gsm/";
    };
  };
}) x

