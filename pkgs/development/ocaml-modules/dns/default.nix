{ lib, buildDunePackage, fetchurl, alcotest
, cstruct, domain-name, duration, gmap, ipaddr, logs, lru, metrics, ptime, rresult
}:

buildDunePackage rec {
  pname = "dns";
  version = "4.4.1";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-v${version}.tbz";
    sha256 = "18c09jf0kicv2xz40n367y774rg8qs07rr1vdk8bx8f7hnaa9cn8";
  };

  propagatedBuildInputs = [ cstruct domain-name duration gmap ipaddr logs lru metrics ptime rresult ];

  doCheck = true;
  checkInputs = lib.optional doCheck alcotest;

  meta = {
    description = "An Domain Name System (DNS) library";
    homepage = "https://github.com/mirage/ocaml-dns";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
