{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "trace";
  version = "0.8";

  minimalOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/c-cube/ocaml-trace/releases/download/v${version}/trace-${version}.tbz";
    hash = "sha256-NM+lZithHB4kbw+4Ex7mBe65CzWcEF6IL1Gtx+cIeMM=";
  };

  meta = {
    description = "Common interface for tracing/instrumentation libraries in OCaml";
    license = lib.licenses.mit;
    homepage = "https://c-cube.github.io/ocaml-trace/";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
