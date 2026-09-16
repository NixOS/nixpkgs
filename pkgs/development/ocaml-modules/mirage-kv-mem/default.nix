{
  lib,
  buildDunePackage,
  fetchurl,
  alcotest,
  fmt,
  mirage-kv,
  mirage-ptime,
  optint,
  ptime,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-kv-mem";
  version = "4.0.1";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-kv-mem/releases/download/v${finalAttrs.version}/mirage-kv-mem-${finalAttrs.version}.tbz";
    hash = "sha256-e5YRhYg3KO5LwFmi1JvnqlF3moeAkOa+MfKQPIqeXlE=";
  };

  propagatedBuildInputs = [
    fmt
    mirage-kv
    mirage-ptime
    optint
    ptime
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "MirageOS key-value store implementation in memory, not persistent";
    homepage = "https://github.com/mirage/mirage-kv-mem";
    changelog = "https://github.com/mirage/mirage-kv-mem/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.stepbrobd ];
  };
})
