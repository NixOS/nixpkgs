{
  lib,
  fetchurl,
  buildDunePackage,
  dune-configurator,
  optint,
  fmt,
  rresult,
  bos,
  fpath,
  astring,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  version = "0.5.3";
  pname = "checkseum";

  src = fetchurl {
    url = "https://github.com/mirage/checkseum/releases/download/v${finalAttrs.version}/checkseum-${finalAttrs.version}.tbz";
    hash = "sha256-uIwRmUNBITo1wj80Fou6enS/P4kFH3e+s52COtzhpTE=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    optint
  ];

  checkInputs = [
    alcotest
    bos
    astring
    fmt
    fpath
    rresult
  ];

  doCheck = true;

  meta = {
    description = "ADLER-32 and CRC32C Cyclic Redundancy Check";
    homepage = "https://github.com/mirage/checkseum";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "checkseum.checkseum";
  };
})
