{ lib, buildFHSUserEnv }:

let
  pio-pkgs = pkgs:
    let
      python = pkgs.python.override {
        packageOverrides = self: super: {

          # https://github.com/platformio/platformio-core/issues/349
          click = super.click.overridePythonAttrs (oldAttrs: rec {
            version = "5.1";
            src = oldAttrs.src.override {
              inherit version;
              sha256 = "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a";
            };
          });

          platformio = self.callPackage ./core.nix { };
        };
      };
    in (with pkgs; [
      zlib
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
    homepage = http://platformio.org;
    maintainers = with maintainers; [ mog ];
    license = licenses.asl20;
    platforms = with platforms; linux;
  };

  extraInstallCommands = ''
    ln -s $out/bin/platformio $out/bin/pio
  '';

  runScript = "platformio";
}
