{
  lib,
  fetchzip,
  buildDunePackage,
  windtrap,
}:

buildDunePackage (finalAttrs: {
  pname = "thumper";
  version = "0.1.0";

  src = fetchzip {
    url = "https://github.com/invariant-hq/thumper/releases/download/v0.1.0/thumper-${finalAttrs.version}.tbz";
    hash = "sha256-MGmVyfsTktEGXJyejaXBoz80lNQHVI8aqOzku1t9ntM=";
  };

  minimalOCamlVersion = "5.2";

  checkInputs = [
    windtrap
  ];

  doCheck = true;

  meta = {
    description = "Benchmark regression tests for OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/invariant-hq/thumper";
    changelog = "https://raw.githubusercontent.com/invariant-hq/thumper/refs/tags/${finalAttrs.version}/CHANGES.md";
    maintainers = with lib.maintainers; [
      toastal
    ];
    platforms = lib.platforms.unix;
  };
})
