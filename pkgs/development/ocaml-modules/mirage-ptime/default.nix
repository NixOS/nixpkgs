{
  lib,
  buildDunePackage,
  fetchurl,
  ptime,
  version ? "5.0.0",
}:

buildDunePackage {
  inherit version;

  pname = "mirage-ptime";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-ptime/releases/download/v${version}/mirage-ptime-${version}.tbz";
    hash = "sha256-1VNWBGjVuU2yWwVzjCSZ8pDuZrFKwitDAuZn8fpENHE=";
  };

  propagatedBuildInputs = [ ptime ];

  meta = {
    description = "A POSIX clock for MirageOS";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    changelog = "https://raw.githubusercontent.com/mirage/mirage-ptime/refs/tags/v${version}/CHANGES.md";
    homepage = "https://github.com/mirage/mirage-ptime";
  };
}
