{
  lib,
  stdenv,
  buildDunePackage,
  fetchFromGitHub,
  cstruct,
  duration,
  ethernet,
  ipaddr,
  logs,
  lwt,
  macaddr,
  mirage-sleep,
  alcotest,
  bos,
  mirage-vnetif,
}:

buildDunePackage (finalAttrs: {
  pname = "arp";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "arp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B19xVWcN5q3/+JcitcW1kQp9X0HZOKH89eoJrdwaGdI=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    cstruct
    duration
    ethernet
    ipaddr
    logs
    lwt
    macaddr
    mirage-sleep
  ];

  ## NOTE: As of 18 april 2023 and ARP version 3.0.0, tests fail on Darwin.
  doCheck = !stdenv.hostPlatform.isDarwin;
  checkInputs = [
    alcotest
    bos
    mirage-vnetif
  ];

  meta = {
    description = "Address Resolution Protocol purely in OCaml";
    homepage = "https://github.com/mirage/arp";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
})
