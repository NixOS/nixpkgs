{ wireplumber }:
self: {
  source = self.callPackage ./source.nix { };
  buildAstalModule = self.callPackage ./buildAstalModule.nix { };

  apps = self.callPackage ./modules/apps.nix { };
  astal3 = self.callPackage ./modules/astal3.nix { };
  astal4 = self.callPackage ./modules/astal4.nix { };
  auth = self.callPackage ./modules/auth.nix { };
  battery = self.callPackage ./modules/battery.nix { };
  bluetooth = self.callPackage ./modules/bluetooth.nix { };
  cava = self.callPackage ./modules/cava.nix { };
  gjs = self.callPackage ./modules/gjs.nix { };
  greet = self.callPackage ./modules/greet.nix { };
  hyprland = self.callPackage ./modules/hyprland.nix { };
  io = self.callPackage ./modules/io.nix { };
  mpris = self.callPackage ./modules/mpris.nix { };
  network = self.callPackage ./modules/network.nix { };
  notifd = self.callPackage ./modules/notifd.nix { };
  powerprofiles = self.callPackage ./modules/powerprofiles.nix { };
  river = self.callPackage ./modules/river.nix { };
  tray = self.callPackage ./modules/tray.nix { };
  wireplumber = self.callPackage ./modules/wireplumber.nix { inherit wireplumber; };
}
