{
  afl-persistent,
  alcotest,
  buildDunePackage,
  calendar,
  cmdliner,
  fetchurl,
  fpath,
  lib,
  ocaml,
  pprint,
  uucp,
  uunf,
}:

buildDunePackage (finalAttrs: {
  pname = "alcobar";
  version = "0.4.0";
  minimalOCamlVersion = "4.10";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/samoht/alcobar/releases/download/v${finalAttrs.version}/alcobar-${finalAttrs.version}.tbz";
    hash = "sha256-4ASlhN62YFtP+cZmY6yo8P8HjDkOuviBw+qgA70a7oE=";
  };

  propagatedBuildInputs = [
    afl-persistent
    alcotest
    cmdliner
  ];

  checkInputs = [
    calendar
    fpath
    pprint
    uucp
    uunf
  ];
  doCheck = lib.versionAtLeast ocaml.version "5.0";

  meta = {
    description = "Crowbar with an Alcotest-compatible API";
    homepage = "https://github.com/samoht/alcobar";
    changelog = "https://github.com/samoht/alcobar/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vog ];
  };
})
