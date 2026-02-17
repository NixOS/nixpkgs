{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "benchmark";
  version = "1.7";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/Chris00/ocaml-benchmark/releases/download/v${finalAttrs.version}/benchmark-${finalAttrs.version}.tbz";
    hash = "sha256-Aij7vJzamNWQfjLeGgENlIp6Il8+Wc9hsahr4eDGs68=";
  };

  meta = {
    homepage = "https://github.com/Chris00/ocaml-benchmark";
    description = "Benchmark running times of code";
    longDescription = ''
      This module provides a set of tools to measure the running times of
      your functions and to easily compare the results.  A statistical test
      is used to determine whether the results truly differ.
    '';
    changelog = "https://raw.githubusercontent.com/Chris00/ocaml-benchmark/refs/tags/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ momeemt ];
  };
})
