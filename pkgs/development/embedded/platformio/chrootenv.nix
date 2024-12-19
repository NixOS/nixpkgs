{
  lib,
  buildFHSEnv,
  platformio-core,
}:

let
  pio-pkgs =
    pkgs:
    let
      inherit (platformio-core) python;
    in
    (with pkgs; [
      platformio-core
      zlib
      git
      xdg-user-dirs
      ncurses
      udev
    ])
    ++ (with python.pkgs; [
      python
      setuptools
      pip
      bottle
    ]);

in
buildFHSEnv {
  pname = "platformio";
  inherit (platformio-core) version;

  targetPkgs = pio-pkgs;
  # disabled temporarily because fastdiff no longer support 32bit
  # multiPkgs = pio-pkgs;

  meta = with lib; {
    description = "Open source ecosystem for IoT development";
    homepage = "https://platformio.org";
    maintainers = with maintainers; [ mog ];
    license = licenses.asl20;
    platforms = with platforms; linux;
  };

  extraInstallCommands = ''
    ln -s $out/bin/platformio $out/bin/pio
    ln -s ${platformio-core.udev}/lib $out/lib
  '';

  runScript = "platformio";
}
