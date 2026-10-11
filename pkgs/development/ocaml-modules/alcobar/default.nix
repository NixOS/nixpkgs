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
  version = "0.3.2";
  minimalOCamlVersion = "4.10";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/samoht/alcobar/releases/download/v${finalAttrs.version}/alcobar-${finalAttrs.version}.tbz";
    hash = "sha256-JbSD0yuuof+eiH59ieAd5UGx+duny6QeiCM9nzwTsRE=";
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
