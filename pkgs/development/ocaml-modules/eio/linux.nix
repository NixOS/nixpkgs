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

  minimalOCamlVersion = "5.2";

  dontStrip = true;

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [
    eio
    fmt
    logs
    uring
  ];
}
