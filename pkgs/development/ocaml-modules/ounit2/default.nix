{
  lib,
  buildDunePackage,
  fetchurl,
  seq,
  stdlib-shims,
}:

buildDunePackage (finalAttrs: {
  minimalOCamlVersion = "4.08";

  pname = "ounit2";
  version = "2.2.7";

  src = fetchurl {
    url = "https://github.com/gildor478/ounit/releases/download/v${finalAttrs.version}/ounit-${finalAttrs.version}.tbz";
    hash = "sha256-kPbmO9EkClHYubL3IgWb15zgC1J2vdYji49cYTwOc4g=";
  };

  propagatedBuildInputs = [
    seq
    stdlib-shims
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/gildor478/ounit";
    description = "Unit test framework for OCaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
})
