{
  lib,
  buildDunePackage,
  fetchurl,
  mirage-flow,
  cstruct,
  logs,
  ke,
  lwt,
  alcotest,
  alcotest-lwt,
  bigstringaf,
}:

buildDunePackage (finalAttrs: {
  pname = "mimic";
  version = "0.0.9";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/dinosaure/mimic/releases/download/${finalAttrs.version}/mimic-${finalAttrs.version}.tbz";
    hash = "sha256-lU3xzrVIqSKnhUQIhaXRamr39zXWw3DtNdM5EUtp4p8=";
  };

  propagatedBuildInputs = [
    lwt
    mirage-flow
    logs
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    alcotest-lwt
    bigstringaf
    cstruct
    ke
  ];

  meta = {
    description = "Simple protocol dispatcher";
    license = lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-git";
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
