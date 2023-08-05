{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "trace";
  version = "0.2";

  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/c-cube/trace/releases/download/v${version}/trace-${version}.tbz";
    hash = "sha256-iScnZxjgzDqZFxbDDXB0K4TkdDJDcrMC03sK/ltbqJQ=";
  };

  meta = {
    description = "Common interface for tracing/instrumentation libraries in OCaml";
    license = lib.licenses.mit;
    homepage = "https://c-cube.github.io/trace/";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
