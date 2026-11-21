{
  lib,
  buildDunePackage,
  fetchurl,
  astring,
  cmdliner,
  fmt,
  re,
  stdlib-shims,
  uutf,
  ocaml-syntax-shims,
}:

buildDunePackage (finalAttrs: {
  pname = "alcotest";
  version = "1.10.2";

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${finalAttrs.version}/alcotest-${finalAttrs.version}.tbz";
    hash = "sha256-bg2ogo+/aCbeC3gt/jLEX5/uekTx1iV8aX0M+Sz+zTY=";
  };

  nativeBuildInputs = [ ocaml-syntax-shims ];

  propagatedBuildInputs = [
    astring
    cmdliner
    fmt
    re
    stdlib-shims
    uutf
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/alcotest";
    description = "Lightweight and colourful test framework";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ericbmerritt ];
  };
})
