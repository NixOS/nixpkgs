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
  version = "1.9.1";

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${finalAttrs.version}/alcotest-${finalAttrs.version}.tbz";
    hash = "sha256-HinDtB1DKQYhBbcj39o6/4a4zvXnx1ANDkkfxf145II=";
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
