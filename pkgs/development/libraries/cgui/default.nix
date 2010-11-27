x@{builderDefsPackage
  , texinfo, allegro, perl
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="cgui";
    version="2.0.3";
    name="${baseName}-${version}";
    project="${baseName}";
    url="mirror://sourceforge/project/${project}/${version}/${name}.tar.gz";
    hash="00kk4xaw68m44awy8zq4g5plx372swwccvzshn68a0a8f3f2wi4x";
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
  phaseNames = ["genMakefile" "doMakeInstall"];

  genMakefile = a.fullDepEntry (''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fPIC"
    sh fix.sh unix
  '') ["minInit" "doUnpack" "addInputs"];
      
  makeFlags = [
    "SYSTEM_DIR=$out"
  ];

  meta = {
    description = "A multiplatform basic GUI library";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/cgui/files/";
    };
  };
}) x

