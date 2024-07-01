{ lib
, stdenv
, pkgs
, makeSetupHook
, waf
}:

makeSetupHook {
  name = "waf-setup-hook";

  substitutions = {
    # Sometimes the upstream provides its own waf file; in order to honor it,
    # waf is not inserted into propagatedBuildInputs, rather it is inserted
    # directly
    inherit waf;
  };

  meta = {
    description = "Setup hook for using Waf in Nixpkgs";
    inherit (waf.meta) maintainers platforms broken;
  };
} ./setup-hook.sh
