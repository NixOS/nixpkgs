{ lib, buildDunePackage, fetchurl, alcotest
, cstruct, domain-name, duration, gmap, ipaddr, logs, lru, metrics, ptime, fmt
, base64
}:

buildDunePackage rec {
  pname = "dns";
  version = "6.3.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-${version}.tbz";
    sha256 = "sha256-3EAjenN9EIi4PsXCZDevmEPDaS4xbESbcbB7pFgwc1E=";
  };

  propagatedBuildInputs = [ fmt logs ptime domain-name gmap cstruct ipaddr lru duration metrics base64 ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "An Domain Name System (DNS) library";
    homepage = "https://github.com/mirage/ocaml-dns";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
