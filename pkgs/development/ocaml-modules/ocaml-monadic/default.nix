{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ppxlib,
}:

buildDunePackage (finalAttrs: {
  pname = "ocaml-monadic";
  version = "0.5.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "zepalmer";
    repo = "ocaml-monadic";
    rev = finalAttrs.version;
    hash = "sha256-fD3n6KdNPJkRhDnx3TQZiTHps9mzMPPtm3BW3KAf2/o=";
  };

  buildInputs = [ ppxlib ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "PPX extension to provide an OCaml-friendly monadic syntax";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
