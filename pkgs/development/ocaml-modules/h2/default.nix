{
  buildDunePackage,
  lib,
  fetchFromGitHub,
  ocaml,
  hpack,
  angstrom,
  faraday,
  base64,
  psq,
  httpaf,
  alcotest,
  yojson,
  hex,
}:

let
  http2-frame-test-case = fetchFromGitHub {
    owner = "http2jp";
    repo = "http2-frame-test-case";
    rev = "5c67db0d4d68e1fb7d3a241d6e01fc04d981f465";
    sha256 = "16yyb37f8mk9saw7ndjs5is67yq7qa6b6y7k0c75ibxi4n9aw1r3";
  };
in

buildDunePackage rec {
  pname = "h2";

  inherit (hpack)
    version
    src
    ;

  propagatedBuildInputs = [
    angstrom
    faraday
    base64
    psq
    hpack
    httpaf
  ];

  doCheck = true;
  preCheck = ''
    ln -s "${http2-frame-test-case}" lib_test/http2-frame-test-case
  '';
  checkInputs = [
    alcotest
    yojson
    hex
  ];

  meta = hpack.meta // {
    description = "A high-performance, memory-efficient, and scalable HTTP/2 library for OCaml";
  };
}
