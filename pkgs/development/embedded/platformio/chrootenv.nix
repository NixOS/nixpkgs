{ lib, buildFHSUserEnv, version, src, meta }:

let
  pio-pkgs = pkgs:
    let
      python = pkgs.python3.override {
        packageOverrides = self: super: {
          platformio = self.callPackage ./core.nix { inherit version src meta; };
        };
      };
    in
    (with pkgs; [
      zlib
      git
      xdg-user-dirs
    ]) ++ (with python.pkgs; [
      python
      setuptools
      pip
      bottle
      platformio
    ]);

in
buildFHSUserEnv {
  name = "platformio";

  targetPkgs = pio-pkgs;
  # disabled temporarily because fastdiff no longer support 32bit
  # multiPkgs = pio-pkgs;

  inherit meta;

  extraInstallCommands = ''
    mkdir -p $out/lib/udev/rules.d

    ln -s $out/bin/platformio $out/bin/pio
    ln -s ${src}/scripts/99-platformio-udev.rules $out/lib/udev/rules.d/99-platformio-udev.rules
  '';

  runScript = "platformio";
}
