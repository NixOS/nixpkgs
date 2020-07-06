{ lib, buildDunePackage, fetchurl, alcotest
, cstruct, domain-name, duration, gmap, ipaddr, logs, lru, metrics, ptime, rresult, astring, fmt
}:

buildDunePackage rec {
  pname = "dns";
  version = "4.6.1";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-v${version}.tbz";
    sha256 = "0nsx98r2i1siz0yghnh87f2sq8w79if7ih9259yay1bp39crd6gd";
  };

  propagatedBuildInputs = [ rresult astring fmt logs ptime domain-name gmap cstruct ipaddr lru duration metrics ];

  doCheck = true;
  checkInputs = lib.optional doCheck alcotest;

  meta = {
    description = "An Domain Name System (DNS) library";
    homepage = "https://github.com/mirage/ocaml-dns";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
