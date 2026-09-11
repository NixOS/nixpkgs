{
  lib,
  fetchzip,
  buildDunePackage,
  odoc,
  bytesrw,
  fmt,
  jsont,
  uucp,
  uuseg,
  alcobar,
  alcotest,
  astring,
  cmdliner,
  k7,
  logs,
  matrix,
  mdx,
  re,
}:

buildDunePackage (finalAttrs: {
  pname = "console";
  version = "0.10.0";

  src = fetchzip {
    url = "https://github.com/samoht/ocaml-console/releases/download/${finalAttrs.version}/console-${finalAttrs.version}.tbz";
    hash = "sha256-EUvLN1glqaL7sDyqZR37FN/gnTYLz/A5FUPSL/82J28=";
  };

  minimalOCamlVersion = "5.4";

  nativeBuildInputs = [
    odoc
  ];

  propagatedBuildInputs = [
    bytesrw
    fmt
    (jsont.override { withBytesrw = true; })
    uucp
    uuseg
  ];

  nativeCheckInputs = [
    k7
    (mdx.override { inherit logs; })
  ];

  checkInputs = [
    alcobar
    alcotest
    astring
    cmdliner
    matrix
    (mdx.override { inherit logs; })
    re
  ];

  doCheck = true;

  meta = {
    description = "Colours, tables, trees and progress rows for OCaml command-line tools";
    license = lib.licenses.isc;
    homepage = "https://github.com/samoht/ocaml-console";
    changelog = "https://raw.githubusercontent.com/samoht/ocaml-console/refs/tags/${finalAttrs.version}/CHANGES.md";
    maintainers = with lib.maintainers; [
      marijanp
      toastal
    ];
  };
})
