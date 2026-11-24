{
  lib,
  buildDunePackage,
  ocaml,
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
  version = if lib.versionAtLeast ocaml.version "4.14" then "1.10.0" else "1.9.1";

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${finalAttrs.version}/alcotest-${finalAttrs.version}.tbz";
    hash =
      {
        "1.10.0" = "sha256-5B9Zs9rquSfatrvstoXt9myHKYjzcmhWgHmpvfwxSXw=";
        "1.9.1" = "sha256-HinDtB1DKQYhBbcj39o6/4a4zvXnx1ANDkkfxf145II=";
      }
      ."${finalAttrs.version}";
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
