{
  lib,
  fetchurl,
  buildDunePackage,
  menhir,
}:

buildDunePackage (finalAttrs: {
  pname = "opam-file-format";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/ocaml/opam-file-format/releases/download/${finalAttrs.version}/opam-file-format-${finalAttrs.version}.tar.gz";
    hash = "sha256-SrU1Cw3L1EwFmrDFnYE2jzSvdwccDmXYHGpbm/ql6Ck=";
  };

  nativeBuildInputs = [ menhir ];

  meta = {
    description = "Parser and printer for the opam file syntax";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ vbgl ];
    homepage = "https://github.com/ocaml/opam-file-format/";
    changelog = "https://github.com/ocaml/opam-file-format/raw/${finalAttrs.version}/CHANGES";
  };
})
