{
  lib,
  buildDunePackage,
  dune-configurator,
  eio,
  fmt,
  logs,
  uring,
}:

buildDunePackage {
  pname = "eio_linux";
  inherit (eio)
    meta
    src
    patches
    version
    ;

  minimalOCamlVersion = "5.0";

  dontStrip = true;

  buildInputs = lib.optional (lib.versionAtLeast eio.version "1.4") dune-configurator;

  propagatedBuildInputs = [
    eio
    fmt
    logs
    uring
  ];
}
