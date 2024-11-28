{
  lib,
  buildDunePackage,
  get-activity-lib,
  ppx_expect,
  cmdliner,
  dune-build-info,
  fmt,
  logs,
  alcotest
}:

buildDunePackage rec {
  pname = "get-activity";
  inherit (get-activity-lib) version src;

  minimalOCamlVersion = "4.08";

  buildInputs = [
    get-activity-lib
    cmdliner
    dune-build-info
    fmt
    logs
  ];

  checkInputs = [ ppx_expect alcotest ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/tarides/get-activity";
    description = "Collect activity and format as markdown for a journal";
    license = lib.licenses.mit;
    changelog = "https://github.com/tarides/get-activity/releases/tag/${version}";
    maintainers = with lib.maintainers; [ zazedd ];
  };
}
