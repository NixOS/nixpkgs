{
  lib,
  fetchurl,
  fetchpatch,
  buildDunePackage,
  alcotest,
  camlp-streams,
  dream,
  dune-site,
  lwt_ppx,
  menhir,
  ppx_inline_test,
  pratter,
  sedlex,
  timed,
  why3,
  yojson,
}:

buildDunePackage (finalAttrs: {
  pname = "lambdapi";
  version = "4.0.0";

  minimalOCamlVersion = "4.14";

  src = fetchurl {
    url = "https://github.com/Deducteam/lambdapi/releases/download/${finalAttrs.version}/lambdapi-${finalAttrs.version}.tbz";
    hash = "sha256-Di5z4OoMZ08SY7+F7TRT7T1ghNOO6imXSgO6njgtKdc=";
  };

  nativeBuildInputs = [
    dream
    menhir
  ];
  buildInputs = [ lwt_ppx ];
  propagatedBuildInputs = [
    camlp-streams
    dream
    dune-site
    ppx_inline_test
    pratter
    sedlex
    timed
    why3
    yojson
  ];

  checkInputs = [
    alcotest
  ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/Deducteam/lambdapi";
    description = "Proof assistant based on the λΠ-calculus modulo rewriting";
    license = lib.licenses.cecill21;
    changelog = "https://github.com/Deducteam/lambdapi/raw/${finalAttrs.version}/CHANGES.md";
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
