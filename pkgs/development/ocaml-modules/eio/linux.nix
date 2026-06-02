{
  buildDunePackage,
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

  propagatedBuildInputs = [
    eio
    fmt
    logs
    uring
  ];
}
