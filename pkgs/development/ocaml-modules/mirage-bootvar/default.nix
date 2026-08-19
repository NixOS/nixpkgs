{
  lib,
  fetchurl,
  buildDunePackage,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-bootvar";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-bootvar/releases/download/v${finalAttrs.version}/mirage-bootvar-${finalAttrs.version}.tbz";
    hash = "sha256-EuXvtt2nap3B7jY7nYMenOqamLTQruyFJ8K2tRZ4Bq0=";
  };

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = {
    description = "Boot time arguments for MirageOS";
    homepage = "https://github.com/mirage/mirage-bootvar";
    changelog = "https://raw.githubusercontent.com/mirage/mirage-bootvar/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.stepbrobd ];
    teams = [ lib.teams.ngi ];
  };
})
