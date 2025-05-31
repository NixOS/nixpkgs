{
  lib,
  makeSetupHook,
  systemdMinimal,
  udev,
  stdenv,
}:
let
  # udev rules can only be checked if systemd (specifically, 'udevadm') can be executed on build platform
  # if udev is not available on hostPlatform, there is no point in checking rules
  applyHook =
    lib.meta.availableOn stdenv.hostPlatform udev
    && lib.meta.availableOn stdenv.buildPlatform systemdMinimal;
in
makeSetupHook {
  name = "udev-check-hook";
  substitutions = {
    udevadm = if applyHook then lib.getExe' systemdMinimal "udevadm" else "";
  };
  meta = {
    description = "check validity of udev rules in outputs";
    maintainers = with lib.maintainers; [ grimmauld ];
  };
} ./hook.sh
