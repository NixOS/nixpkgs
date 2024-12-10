{
  lib,
  stdenv,
  pkgs,
  makeSetupHook,
  waf,
}:

makeSetupHook {
  name = "waf-setup-hook";

  substitutions = {
    # Sometimes the upstream provides its own waf file; in order to honor it,
    # waf is not inserted into propagatedBuildInputs, rather it is inserted
    # directly
    inherit waf;
    wafCrossFlags = lib.optionalString (
      stdenv.hostPlatform.system != stdenv.targetPlatform.system
    ) ''--cross-compile "--cross-execute=${stdenv.targetPlatform.emulator pkgs}"'';
  };

  meta = {
    description = "A setup hook for using Waf in Nixpkgs";
    inherit (waf.meta) maintainers platforms broken;
  };
} ./setup-hook.sh
