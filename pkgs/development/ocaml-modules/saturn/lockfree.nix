{
  lib,
  fetchurl,
  buildDunePackage,
  backoff,
  multicore-magic,
}:

buildDunePackage rec {
  pname = "saturn_lockfree";
  version = "0.5.0";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/saturn/releases/download/${version}/saturn-${version}.tbz";
    hash = "sha256-ZmmxwIe5PiPYTTdvOHbOjRbv2b/bb9y0IekByfREPjk=";
  };

  propagatedBuildInputs = [
    backoff
    multicore-magic
  ];

  meta = with lib; {
    description = "Lock-free data structures for multicore OCaml";
    homepage = "https://github.com/ocaml-multicore/lockfree";
    license = licenses.isc;
    maintainers = [ maintainers.vbgl ];
  };
}
