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
    rev = "v4.3.4";
    sha256 = "0vf2j79319ypr4yrdmx84853igkb188sjfvlxgw06rlsvsm3kacq";
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
