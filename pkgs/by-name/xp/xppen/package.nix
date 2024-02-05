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
    "--ro-bind ${xppen-unwrapped}/usr/lib/pentablet /var/lib/pentablet"
  ];

  extraBuildCommands = ''
    mkdir -p $out/var/lib/pentablet
  '';

  meta = xppen-unwrapped.meta;
}
