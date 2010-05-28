x@{stdenv, fetchurl, builderDefsPackage, ...}:
builderDefsPackage
(a :  
let 
  s = import ./src-for-default.nix;
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ [];
  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = ["--enable-shared"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "Gambit Scheme to C compiler";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms;
      linux ++ freebsd;
  };
}) x
