{
  lib,
  fetchurl,
  ocaml,
  buildDunePackage,
  ppxlib,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_deriving_variant_string";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/ahrefs/ppx_deriving_variant_string/releases/download/${finalAttrs.version}/ppx_deriving_variant_string-${finalAttrs.version}.tbz";
    hash = "sha256-24m53iwGHbRfTzxiAN055CJ3zLzZ4Syl2Wi28UDlTBQ=";
  };

  propagatedBuildInputs = [
    ppxlib
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.12";
  checkInputs = [
    ounit2
  ];

  meta = {
    homepage = "https://github.com/ahrefs/ppx_deriving_variant_string";
    description = "OCaml PPX deriver that generates converters between regular or polymorphic variants and strings.";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.marijanp ];
    changelog = "https://raw.githubusercontent.com/ahrefs/ppx_deriving_variant_string/${finalAttrs.version}/CHANGES.md";
  };
})
