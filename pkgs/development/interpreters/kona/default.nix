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
    sha256 = "165ff5f3d1b510a1ad73ec465b4ed1b8ef44d7affa94f952781fea212c72d891";
  };

  src = "${srcDrv}/";

  rev = "fddc2688ef515a653fb6";
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

