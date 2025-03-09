{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "benchmark";
  version = "1.6";

  src = fetchurl {
    url = "https://github.com/Chris00/ocaml-benchmark/releases/download/${version}/benchmark-${version}.tbz";
    hash = "sha256-Mw19cYya/MEy52PVRYE/B6TnqCWw5tEz9CUrUfKAnPA=";
  };

  meta = {
    homepage = "https://github.com/Chris00/ocaml-benchmark";
    description = "Benchmark running times of code";
    license = lib.licenses.lgpl21;
  };
}
