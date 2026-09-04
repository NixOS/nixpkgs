{
  lib,
  buildDunePackage,
  fetchurl,
  alcotest,
  base64,
  crowbar,
  cstruct,
  duration,
  fmt,
  ipaddr,
  ipaddr-cstruct,
  logs,
  lwt,
  metrics,
  mirage-crypto-rng,
  mirage-mtime,
  mirage-sleep,
  mtime,
  ohex,
  randomconv,
  tcpip,
}:

buildDunePackage (finalAttrs: {
  pname = "utcp";
  version = "0.0.7";

  __structuredAttrs = true;

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://git.robur.coop/robur/utcp/releases/download/v${finalAttrs.version}/utcp-${finalAttrs.version}.tbz";
    hash = "sha256-jUHehG6WgQOfpuMS1TDBEYAv5hUu+iLV9C9MGteoVAM=";
  };

  propagatedBuildInputs = [
    base64
    cstruct
    duration
    fmt
    ipaddr
    ipaddr-cstruct
    logs
    lwt
    metrics
    mirage-crypto-rng
    mirage-mtime
    mirage-sleep
    mtime
    randomconv
    tcpip
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    crowbar
    ohex
  ];

  meta = {
    description = "Implementation of the Transmission Control Protocol in OCaml";
    homepage = "https://github.com/robur-coop/utcp";
    changelog = "https://github.com/robur-coop/utcp/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.stepbrobd ];
  };
})
