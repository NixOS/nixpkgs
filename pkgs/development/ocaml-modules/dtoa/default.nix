{
  stdenv,
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "dtoa";
  version = "0.3.3";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-dtoa/releases/download/v${finalAttrs.version}/dtoa-${finalAttrs.version}.tbz";
    hash = "sha256-2PRgjJ6Ssp4l6jHzv1/MqzlomQlJkKLVnRXG6KPJ7j4=";
  };

  checkInputs = [ ounit2 ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  hardeningDisable = lib.optional stdenv.cc.isClang "strictoverflow";

  meta = {
    homepage = "https://github.com/flowtype/ocaml-dtoa";
    description = "Converts OCaml floats into strings (doubles to ascii, \"d to a\"), using the efficient Grisu3 algorithm";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eqyiel ];
  };
})
