{
  lib,
  buildDunePackage,
  fetchurl,
  ipaddr,
  cstruct,
  logs,
  lru,
  tcpip,
  ethernet,
  alcotest,
  mirage-clock-unix,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-nat";
  version = "3.1.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-nat/releases/download/v${finalAttrs.version}/mirage-nat-${finalAttrs.version}.tbz";
    hash = "sha256-u1jSVMdV9bfcfbetN+zwRUWlMSgcpjEBvJlAyDZCrvA=";
  };

  propagatedBuildInputs = [
    ipaddr
    cstruct
    logs
    lru
    tcpip
    ethernet
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mirage-clock-unix
  ];

  meta = {
    description = "Mirage-nat is a library for network address translation to be used with MirageOS";
    homepage = "https://github.com/mirage/mirage-nat";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
