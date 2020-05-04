{ lib, buildDunePackage, fetchurl, alcotest
, cstruct, domain-name, duration, gmap, ipaddr, logs, lru, metrics, ptime, rresult
}:

buildDunePackage rec {
  pname = "dns";
  version = "4.5.0";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-v${version}.tbz";
    sha256 = "10jrnnxvp06rvzk285wibyi9hn15qhjnqjy9xsfbwl8yhmzzqnq0";
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
