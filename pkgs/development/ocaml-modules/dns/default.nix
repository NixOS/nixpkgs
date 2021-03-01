{ lib, buildDunePackage, fetchurl, alcotest
, cstruct, domain-name, duration, gmap, ipaddr, logs, lru, metrics, ptime, rresult, astring, fmt
}:

buildDunePackage rec {
  pname = "dns";
  version = "4.6.3";

  useDune2 = true;
  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-v${version}.tbz";
    sha256 = "0g7xw43jm5hv0w9lsnhhi0w3243mxl615cdsvz29yh39fcqvqsdy";
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
