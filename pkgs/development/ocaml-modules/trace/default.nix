{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "trace";
  version = "0.3";

  minimalOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/c-cube/ocaml-trace/releases/download/${version}/trace-${version}.tbz";
    hash = "sha256-Krq6qYO7tKJktTRjFrdmONPHfjrd81Ighsb9nmG9ZQU=";
  };

  meta = {
    description = "Common interface for tracing/instrumentation libraries in OCaml";
    license = lib.licenses.mit;
    homepage = "https://c-cube.github.io/ocaml-trace/";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
