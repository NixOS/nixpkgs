{ lib, buildFHSUserEnv, platformio, stdenv }:

buildFHSUserEnv {
  name = "platformio";

  targetPkgs = pkgs: (with pkgs;
    [
      python27Packages.python
      python27Packages.setuptools
      python27Packages.pip
      python27Packages.bottle
      python27Packages.platformio
      zlib
    ]);
  multiPkgs = pkgs: (with pkgs;
    [
      python27Packages.python
      python27Packages.setuptools
      python27Packages.pip
      python27Packages.bottle
      python27Packages.platformio
      zlib
    ]);

  meta = with stdenv.lib; {
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
