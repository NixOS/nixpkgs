{ lib, buildFHSUserEnv }:

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
    ln -s $out/bin/platformio $out/bin/pio
  '';

  runScript = "platformio";
}
