{ buildDunePackage
, eio
, fmt
, logs
, uring
}:

buildDunePackage {
  pname = "eio_linux";
  inherit (eio) meta src version;

  minimalOCamlVersion = "5.0";
  duneVersion = "3";

  dontStrip = true;

  propagatedBuildInputs = [
    eio
    fmt
    logs
    uring
  ];
}
