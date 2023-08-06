{ lib
, stdenv
, buildDunePackage
, eio
, eio_posix
, eio_linux
}:

buildDunePackage {
  pname = "eio_main";
  inherit (eio) meta src version;

  minimalOCamlVersion = "5.0";
  duneVersion = "3";

  dontStrip = true;

  propagatedBuildInputs = [
    eio_posix
  ] ++ lib.optionals stdenv.isLinux [
    eio_linux
  ];
}
