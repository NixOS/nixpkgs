{
  lib,
  fetchurl,
  buildZigmodPackage,
  zig_0_12,
}:

buildZigmodPackage.override { zig = zig_0_12; } {
  pname = "zigmod-clap-test";
  version = "1";

  src = ./.;

  lockFile = fetchurl {
    url = "file:///" + ./zigmod.lock;
    hash = "sha256-9phQeqUJ9JJmmGqE3vdGnHMFzylH8SkO1dNgTcH08VY=";
  };
  manifestFile = fetchurl {
    url = "file:///" + ./zigmod.yml;
    hash = "sha256-W6SBtM7JJdfCARx0p1VsGdqDeON/nnYhJLOGElwovk8=";
  };

  depsOutputHash = "sha256-/vwtkLpizO2itNluJlvNJE1nwfZoyEOIqPr0efO8Q+Q=";
}
