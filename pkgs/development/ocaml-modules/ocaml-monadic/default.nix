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
    sha256 = "1ynv3yhdqmkhkgnz6c5kv6ryjcc934sdvw9rhh8rjg2dlzlffgbw";
  };

  buildInputs = [ ppxlib ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "PPX extension to provide an OCaml-friendly monadic syntax";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
