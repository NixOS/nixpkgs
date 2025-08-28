{
  lib,
  stdenv,
  buildDunePackage,
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

  propagatedBuildInputs = [
    eio_posix
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    eio_linux
  ];
}
