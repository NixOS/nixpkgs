{ lib
, buildFHSEnv
, xppen-unwrapped
, libusb1
, qt5
, libGL
}:
buildFHSEnv {
  name = "xppen";

  runScript = "PenTablet";

  targetPkgs = pkgs: [
    xppen-unwrapped
    libusb1
    qt5.full
    libGL
  ];

  extraBwrapArgs = [
    "--ro-bind /var/lib/pentablet /var/lib/pentablet"
  ];

  extraBuildCommands = ''
    mkdir -p $out/var/lib/pentablet
  '';

  meta = xppen-unwrapped.meta;
}
