{
  lib,
  buildDunePackage,
  fetchurl,
  alcotest,
  domain-name,
  duration,
  gmap,
  ipaddr,
  logs,
  lru,
  metrics,
  ptime,
  fmt,
  base64,
  ohex,
}:

buildDunePackage (finalAttrs: {
  pname = "dns";
  version = "10.2.5";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${finalAttrs.version}/dns-${finalAttrs.version}.tbz";
    hash = "sha256-I68JGm5MEzIrf5CUV35tct/NXiPE7AD6NSDttP+fX+8=";
  };

  propagatedBuildInputs = [
    fmt
    logs
    ptime
    domain-name
    gmap
    ipaddr
    lru
    duration
    metrics
    base64
    ohex
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Domain Name System (DNS) library";
    homepage = "https://github.com/mirage/ocaml-dns";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

})
