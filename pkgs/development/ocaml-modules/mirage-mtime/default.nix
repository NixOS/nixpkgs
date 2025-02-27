{
  lib,
  fetchurl,
  buildDunePackage,
  mtime,
  version ? "5.0.0",
}:

buildDunePackage {
  pname = "mirage-mtime";

  inherit version;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-mtime/releases/download/v${version}/mirage-mtime-${version}.tbz";
    hash = "sha256-IwdaAyZyj8gfRPxQP9SOwb28AbtVy9PY7qcr0Pns9GU=";
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
