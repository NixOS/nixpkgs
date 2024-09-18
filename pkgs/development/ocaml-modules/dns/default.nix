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
  version = "8.0.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-${version}.tbz";
    hash = "sha256-CIIGG8W/p1FasmyEyoBiMjrFkxs/iuKVJ5SwySfYhU4=";
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
