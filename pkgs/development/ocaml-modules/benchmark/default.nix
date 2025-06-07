{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "benchmark";
  version = "1.7";

  src = fetchurl {
    url = "https://github.com/Chris00/ocaml-benchmark/releases/download/v${version}/benchmark-${version}.tbz";
    hash = "sha256-Aij7vJzamNWQfjLeGgENlIp6Il8+Wc9hsahr4eDGs68=";
  };

  meta = {
    homepage = "https://github.com/Chris00/ocaml-benchmark";
    description = "Benchmark running times of code";
    license = lib.licenses.lgpl3;
  };
}
