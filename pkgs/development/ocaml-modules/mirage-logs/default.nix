{
  lib,
  fetchurl,
  buildDunePackage,
  logs,
  fmt,
  ptime,
  mirage-ptime,
  cmdliner,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-logs";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-logs/releases/download/v${finalAttrs.version}/mirage-logs-${finalAttrs.version}.tbz";
    hash = "sha256-ptt9/Dr9h+W3j/9SAHpWvKZnIgeuBn5oxj72kxiSZ1A=";
  };

  propagatedBuildInputs = [
    logs
    fmt
    ptime
    mirage-ptime
    cmdliner
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Mirage reporter for the Logs library";
    homepage = "https://github.com/mirage/mirage-logs";
    changelog = "https://raw.githubusercontent.com/mirage/mirage-logs/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      stepbrobd
      vbgl
    ];
    teams = [ lib.teams.ngi ];
  };
})
