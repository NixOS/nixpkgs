{
  isoBaseName ? "nixos-graphical-gnome",
  system ? builtins.currentSystem,
  extraModules ? [ ],
}:

let

  module = ../../../../nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix;

  config =
    (import ../../../../nixos/lib/eval-config.nix {
      inherit system;
      modules = [
        module
        { image.baseName = isoBaseName; }
      ]
      ++ extraModules;
    }).config;

in
config.system.build.isoImage
