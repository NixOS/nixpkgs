x@{builderDefsPackage
  , fetchgit
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["fetchgit"];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
in
rec {
  srcDrv = a.fetchgit {
    url = "https://github.com/kevinlawler/kona.git";
    inherit rev;
    sha256 = "a8189c94fca3e62a740eb6823ab3fc571c0960ff5e7a3eb0353e5cf36ef9fdcb";
  };

  src = "${srcDrv}/";

  rev = "81e95b395144f4b02fe8782ad87c1f218b511c43";
  version = "git-${rev}";
  name = "kona-${version}";
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["prepareOut" "doMakeInstall"];
  makeFlags = ["PREFIX=\$out"];

  prepareOut = a.fullDepEntry ''
    mkdir -p "$out/bin"
  '' ["minInit" "defEnsureDir"];
      
  meta = {
    description = "An interpreter of K, APL-like programming language";
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
      downloadPage = "https://github.com/kevinlawler/kona";
    };
  };
}) x

