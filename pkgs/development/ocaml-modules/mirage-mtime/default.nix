{
  lib,
  fetchurl,
  buildDunePackage,
  mtime,
  version ? "5.2.0",
}:

buildDunePackage {
  pname = "mirage-mtime";

  inherit version;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-mtime/releases/download/v${version}/mirage-mtime-${version}.tbz";
    hash = "sha256-kaBDUqQF1SFecku85iRnX9ji18TjbTIlz4BlRuRAib8=";
  };

  propagatedBuildInputs = [
    mtime
  ];

  meta = {
    description = "Monotonic time for MirageOS";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/mirage-mtime";
  };
}
