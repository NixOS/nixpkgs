{
  lib,
  buildDunePackage,
  fetchFromGitHub,

  # propagatedBuildInputs,
  calendar,

  nix-update-script,
}:

buildDunePackage (finalAttrs: {
  pname = "easy_logging";
  version = "0.8.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sapristi";
    repo = "easy_logging";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xy6Rfef7r2K8DTok7AYa/9m3ZEV07LlUeMQSRayLBco=";
  };

  propagatedBuildInputs = [
    calendar
  ];

  doCheck = true;
  # Only run the tests for the `easy_logging` package itself.
  # The other directories belong to the separate `easy_logging_yojson` package, which is not built
  # here and pulls in additional dependencies.
  checkPhase = ''
    runHook preCheck

    dune runtest easy_logging ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Logging module for OCaml";
    homepage = "https://github.com/sapristi/easy_logging";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
  };
})
