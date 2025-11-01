{
  lib,
  uptime-kuma_1,
}:
lib.warnOnInstantiate "pkgs.uptime-kuma will be upgraded to 2.x.x in NixOS 26.05, which might require manual intervention. To upgrade now, set `services.uptime-kuma.package` to `pkgs.uptime-kuma_2` instead, or to `pkgs.uptime-kuma_1` to dismiss this warning. See the upgrade guide at https://github.com/louislam/uptime-kuma/wiki/Migration-From-v1-To-v2" uptime-kuma_1
