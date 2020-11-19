{ lib, buildDunePackage, fetchurl, alcotest
, cstruct, domain-name, duration, gmap, ipaddr, logs, lru, metrics, ptime, rresult, astring, fmt
}:

buildDunePackage rec {
  pname = "dns";
  version = "4.6.2";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-v${version}.tbz";
    sha256 = "0prypr5c589vay4alri78g0sarh06z35did26wn3s3di17d5761q";
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
