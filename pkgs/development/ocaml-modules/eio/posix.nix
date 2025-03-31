{
  buildDunePackage,
  lib,
  stdenv,
  dune-configurator,
  eio,
  fmt,
  logs,
  iomux,
}:

buildDunePackage {
  pname = "eio_posix";
  inherit (eio)
    meta
    src
    patches
    version
    ;

  minimalOCamlVersion = "5.0";

  dontStrip = true;

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";
  };

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    eio
    fmt
    logs
    iomux
  ];
}
