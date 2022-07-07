{ lib, buildDunePackage, fetchurl, alcotest
, cstruct, domain-name, duration, gmap, ipaddr, logs, lru, metrics, ptime, fmt
}:

buildDunePackage rec {
  pname = "dns";
  version = "6.1.4";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-${version}.tbz";
    sha256 = "sha256-nO9hRFOQzm3j57S1xTUC/j8ejSB+aDcsw/pOi893kHY=";
  };

  propagatedBuildInputs = [ fmt logs ptime domain-name gmap cstruct ipaddr lru duration metrics ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "An Domain Name System (DNS) library";
    homepage = "https://github.com/mirage/ocaml-dns";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
