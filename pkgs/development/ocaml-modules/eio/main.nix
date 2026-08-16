{
  lib,
  stdenv,
  buildDunePackage,
  dune-configurator,
  eio,
  eio_posix,
  eio_linux,
}:

buildDunePackage {
  pname = "eio_main";
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
    eio_posix
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    eio_linux
  ];
}
