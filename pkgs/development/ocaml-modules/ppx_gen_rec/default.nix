{
  lib,
  fetchurl,
  buildDunePackage,
  ppxlib,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_gen_rec";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-ppx_gen_rec/releases/download/v${finalAttrs.version}/ppx_gen_rec-v${finalAttrs.version}.tbz";
    sha256 = "sha256-/mMj5UT22KQGVy1sjgEoOgPzyCYyeDPtWJYNDvQ9nlk=";
  };

  minimalOCamlVersion = "4.07";
  duneVersion = "3";

  buildInputs = [ ppxlib ];

  meta = {
    homepage = "https://github.com/flowtype/ocaml-ppx_gen_rec";
    description = "Ppx rewriter that transforms a recursive module expression into a struct";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ frontsideair ];
  };
})
