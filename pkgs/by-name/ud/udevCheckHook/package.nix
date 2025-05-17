{
  lib,
  makeSetupHook,
  systemdMinimal,
}:

makeSetupHook {
  name = "udev-check-hook";
  substitutions = {
    udevadm = lib.getExe' systemdMinimal "udevadm";
  };
  meta = {
    description = "check validity of udev rules in outputs";
    maintainers = with lib.maintainers; [ grimmauld ];
  };
} ./hook.sh
