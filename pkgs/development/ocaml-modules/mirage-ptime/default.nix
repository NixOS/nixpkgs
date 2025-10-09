{
  lib,
  buildDunePackage,
  fetchurl,
  ptime,
  version ? "5.1.0",
}:

buildDunePackage {
  inherit version;

  pname = "mirage-ptime";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-ptime/releases/download/v${version}/mirage-ptime-${version}.tbz";
    hash = "sha256-6bPbMTZeGolRMMN4nmrc+ZZ3HqjnAWtj4V7L4fOKKfY=";
  };

  propagatedBuildInputs = [ ptime ];

  meta = {
    description = "POSIX clock for MirageOS";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    changelog = "https://raw.githubusercontent.com/mirage/mirage-ptime/refs/tags/v${version}/CHANGES.md";
    homepage = "https://github.com/mirage/mirage-ptime";
  };
}
