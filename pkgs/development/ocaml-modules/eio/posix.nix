{ buildDunePackage
, dune-configurator
, eio
, fmt
, logs
, iomux
}:

buildDunePackage {
  pname = "eio_posix";
  inherit (eio) meta src version;

  minimalOCamlVersion = "5.0";

  dontStrip = true;

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
