{
  lib,
  buildDunePackage,
  fetchurl,
  cstruct,
  logs,
  lwt,
  macaddr,
  mirage-net,
}:

buildDunePackage (finalAttrs: {
  pname = "ethernet";
  version = "3.2.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ethernet/releases/download/v${finalAttrs.version}/ethernet-${finalAttrs.version}.tbz";
    hash = "sha256-TB2nAhQiHZ1Dk6n/3i49s9HKNH92yNUl3xl94hByrAk=";
  };

  propagatedBuildInputs = [
    cstruct
    mirage-net
    macaddr
    lwt
    logs
  ];

  meta = {
    description = "OCaml Ethernet (IEEE 802.3) layer, used in MirageOS";
    homepage = "https://github.com/mirage/ethernet";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
