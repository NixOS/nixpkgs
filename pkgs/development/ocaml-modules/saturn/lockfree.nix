{ lib, fetchurl, buildDunePackage
, domain_shims
}:

buildDunePackage rec {
  pname = "saturn_lockfree";
  version = "0.4.1";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/saturn/releases/download/${version}/saturn-${version}.tbz";
    hash = "sha256-tO1aqRGocuogHtE6MYPAMxv5jxbkYjCpttHRxUUpDr0=";
  };

  propagatedBuildInputs = [ domain_shims ];

  meta = {
    description = "Lock-free data structures for multicore OCaml";
    homepage = "https://github.com/ocaml-multicore/lockfree";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
