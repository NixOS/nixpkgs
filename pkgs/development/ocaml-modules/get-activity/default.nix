{
  lib,
  buildDunePackage,
  fetchpatch,
  get-activity-lib,
  ppx_expect,
  cmdliner,
  dune-build-info,
  fmt,
  logs,
  alcotest,
}:

buildDunePackage rec {
  pname = "get-activity";
  inherit (get-activity-lib) version src;

  patches = [
    # Compatibility with cmdliner ≥ 2.0
    (fetchpatch {
      url = "https://github.com/tarides/get-activity/commit/3f1ccbbcf7fc65c69c7752726f6886fc92b986fa.patch";
      hash = "sha256-6uvkBEI/ZCPrJ3Aus0/L86zUIa+kOBD0k8ADMEi+pkI=";
    })
  ];

  buildInputs = [
    get-activity-lib
    cmdliner
    dune-build-info
    fmt
    logs
  ];

  checkInputs = [
    ppx_expect
    alcotest
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/tarides/get-activity";
    description = "Collect activity and format as markdown for a journal";
    license = lib.licenses.mit;
    changelog = "https://github.com/tarides/get-activity/releases/tag/${version}";
    maintainers = with lib.maintainers; [ zazedd ];
  };
}
