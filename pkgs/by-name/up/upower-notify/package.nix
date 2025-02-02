{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

# To use upower-notify, the maintainer suggests adding something like this to your configuration.nix:
#
# service.xserver.displayManager.sessionCommands = ''
#   ${pkgs.dunst}/bin/dunst -shrink -geometry 0x0-50-50 -key space & # ...if don't already have a dbus notification display app
#   (sleep 3; exec ${pkgs.yeshup}/bin/yeshup ${pkgs.go-upower-notify}/bin/upower-notify) &
# '';
buildGoModule {
  pname = "upower-notify";
  version = "0-unstable-2024-07-20";

  src = fetchFromGitHub {
    owner = "omeid";
    repo = "upower-notify";
    rev = "c05ffbba9b8d475573be0908d75ac7c64d74be2d";
    hash = "sha256-y+Cy3jkIfWiqF2HFopafdNSyGVA2ws4250Lg02rVxmo=";
  };

  vendorHash = "sha256-58zK6t3rb+19ilaQaNgsMVFQBYKPIV40ww8klrGbpnw=";
  proxyVendor = true;

  meta = with lib; {
    description = "simple tool to give you Desktop Notifications about your battery";
    mainProgram = "upower-notify";
    homepage = "https://github.com/omeid/upower-notify";
    maintainers = with maintainers; [ kamilchm ];
  };
}
