{ lib
, buildDunePackage
, fetchurl
, alcotest
, cstruct
, domain-name
, duration
, gmap
, ipaddr
, logs
, lru
, metrics
, ptime
, fmt
, base64
}:

buildDunePackage rec {
  pname = "dns";
  version = "7.0.1";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-${version}.tbz";
    hash = "sha256-vDe1U1NbbIPcD1AmMG265ke7651C64mds7KcFHUN4fU=";
  };

  propagatedBuildInputs = [ fmt logs ptime domain-name gmap cstruct ipaddr lru duration metrics base64 ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Domain Name System (DNS) library";
    homepage = "https://github.com/mirage/ocaml-dns";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
