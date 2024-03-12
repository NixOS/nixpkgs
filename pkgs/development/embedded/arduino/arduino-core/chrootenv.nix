{ lib, buildFHSEnv, arduino-core-unwrapped, withGui ? false, withTeensyduino ? false }:
let
  arduino-unwrapped = arduino-core-unwrapped.override { inherit withGui withTeensyduino; };
in
buildFHSEnv {
  name = "arduino";

  targetPkgs =
    pkgs: (with pkgs; [
      ncurses
      arduino-unwrapped
      zlib
      (python3.withPackages (p: with p; [
        pyserial
      ]))
    ]);
  multiArch = false;

  extraInstallCommands = ''
    ${lib.optionalString withGui ''
      # desktop file
      mkdir -p $out/share/applications
      cp ${arduino-core-unwrapped.src}/build/linux/dist/desktop.template $out/share/applications/arduino.desktop
      substituteInPlace $out/share/applications/arduino.desktop \
        --replace '<BINARY_LOCATION>' "$out/bin/arduino" \
        --replace '<ICON_NAME>' "$out/share/arduino/icons/128x128/apps/arduino.png"
      # icon file
      mkdir -p $out/share/arduino
      cp -r ${arduino-core-unwrapped.src}/build/shared/icons $out/share/arduino
    ''}
  '';

  runScript = "arduino";

  meta = arduino-core-unwrapped.meta;
}
