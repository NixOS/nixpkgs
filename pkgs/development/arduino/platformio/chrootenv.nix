{ lib, buildFHSUserEnv, fetchFromGitHub }:

let
  pio-pkgs = pkgs:
    let
      python = pkgs.python3.override {
        packageOverrides = self: super: {
          platformio = self.callPackage ./core.nix { };
        };
      };
    in (with pkgs; [
      zlib
      git
    ]) ++ (with python.pkgs; [
      python
      setuptools
      pip
      bottle
      platformio
    ]);

  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v5.0.1";
    sha256 = "01xh61ldilg6fg95l1p870rld2xffhnl9f9ndvbi5jdn8q634pmw";
  };


in buildFHSUserEnv {
  name = "platformio";

  targetPkgs = pio-pkgs;
  multiPkgs = pio-pkgs;

  meta = with lib; {
    description = "An open source ecosystem for IoT development";
    homepage = "https://platformio.org";
    maintainers = with maintainers; [ mog ];
    license = licenses.asl20;
    platforms = with platforms; linux;
  };

  extraInstallCommands = ''
    mkdir -p $out/lib/udev/rules.d

    ln -s $out/bin/platformio $out/bin/pio
    ln -s ${src}/scripts/99-platformio-udev.rules $out/lib/udev/rules.d/99-platformio-udev.rules
  '';

  runScript = "platformio";
}
