{ lib, buildDunePackage, fetchurl, alcotest, logs, fmt, cmdliner_1_1
, cstruct, domain-name, duration, gmap, ipaddr, lru, metrics, ptime, base64, callPackage
}:


buildDunePackage rec {
  pname = "dns";
  version = "6.2.2";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-${version}.tbz";
    sha256 = "sha256-U4QkRq+suFJRoaRkP6dOGFZx0Pjq87wAgOhfOqzJwn8=";
  };

  propagatedBuildInputs = [
    logs
    fmt
    ptime
    domain-name
    gmap
    cstruct
    ipaddr
    lru
    duration
    metrics
    base64
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "An Domain Name System (DNS) library";
    homepage = "https://github.com/mirage/ocaml-dns";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
