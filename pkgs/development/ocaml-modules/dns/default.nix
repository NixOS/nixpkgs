{ lib, buildDunePackage, fetchurl, alcotest
, cstruct, domain-name, duration, gmap, ipaddr, logs, lru, metrics, ptime, rresult, astring, fmt
}:

buildDunePackage rec {
  pname = "dns";
  version = "5.0.0";

  useDune2 = true;
  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-v${version}.tbz";
    sha256 = "ef93435407955a46e51e3be857a1b00a6765ec3b673d4a859a9536c7e3365111";
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
