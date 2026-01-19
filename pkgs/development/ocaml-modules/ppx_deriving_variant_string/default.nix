{
  lib,
  fetchurl,
  buildDunePackage,
  ppxlib,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_deriving_variant_string";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/ahrefs/ppx_deriving_variant_string/releases/download/${finalAttrs.version}/ppx_deriving_variant_string-${finalAttrs.version}.tbz";
    hash = "sha256-nSU9LEwPOOQuCpNAVQgBGucHuk5wjJ3dDIj708djLwc=";
  };

  propagatedBuildInputs = [
    ppxlib
  ];

  doCheck = true;
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
