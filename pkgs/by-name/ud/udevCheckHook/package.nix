{
  lib,
  makeSetupHook,
  systemdMinimal,
  stdenv,
}:
let
  # udev rules can only be checked if systemd (specifically, 'udevadm') can be executed on build platform
  # If cross-compiling linux -> non-linux, udev rules are still checked, even if they end up being unused.
  # This is not a problem:
  # - If there are no udev rules, the hook is a noop
  # - If the udev rules are broken, they should be flagged as such
  # - if rules are not needed on a target platform where they are broken, they should be deleted from package output
  applyHook = lib.meta.availableOn stdenv.buildPlatform systemdMinimal;
in
makeSetupHook {
  name = "udev-check-hook";
  substitutions = {
    udevadm = if applyHook then lib.getExe' systemdMinimal "udevadm" else "";
  };
  meta = {
    description = "Check validity of udev rules in outputs";
    maintainers = with lib.maintainers; [ grimmauld ];
  };
} ./hook.sh
