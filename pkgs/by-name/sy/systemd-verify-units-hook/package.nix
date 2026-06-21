{
  lib,
  makeSetupHook,
  systemd,
  stdenv,
  bash,
  callPackage,
  bubblewrap,
}:
let
  # systemd units can only be checked if systemd (specifically, 'systemd-analyze') can be executed on build platform
  # If cross-compiling linux -> non-linux, systemd unts are still checked, even if they end up being unused.
  # This is not a problem:
  # - If there are no systemd units, the hook is a noop
  # - If the systemd units are broken, they should be flagged as such
  # - If units are not needed on a target platform where they are broken, they should be deleted from package output
  applyHook = lib.meta.availableOn stdenv.buildPlatform systemd;
in
makeSetupHook {
  name = "systemd-verify-units-hook";
  substitutions = {
    shell = "${bash}/bin/bash";
    systemdanalyze = if applyHook then lib.getExe' systemd "systemd-analyze" else "";
    bwrap = if applyHook then lib.getExe bubblewrap else "";
  };

  passthru.tests = {
    simple = callPackage ./test.nix { };
  };

  meta = {
    description = "Check validity of systemd units in outputs";
    platforms = systemd.meta.platforms;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
} ./hook.sh
