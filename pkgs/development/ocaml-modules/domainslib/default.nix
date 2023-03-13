{ lib
, fetchurl
, buildDunePackage
, lockfree
, mirage-clock-unix
}:

buildDunePackage rec {
  pname = "domainslib";
  version = "0.5.0";

  duneVersion = "3";
  minimalOCamlVersion = "5.0";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/domainslib/releases/download/v${version}/domainslib-${version}.tbz";
    hash = "sha256-rty+9DUhTUEcN7BPl8G6Q/G/MJ6z/UAn0RPkG8hACwA=";
  };

  propagatedBuildInputs = [ lockfree ];

  doCheck = true;
  checkInputs = [ mirage-clock-unix ];

  meta = {
    homepage = "https://github.com/ocaml-multicore/domainslib";
    description = "Nested-parallel programming";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
