{
  lib,
  buildDunePackage,
  fetchurl,
  lwt,
  duration,
  version ? "4.0.0",
}:

buildDunePackage {
  inherit version;
  pname = "mirage-sleep";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-sleep/releases/download/v${version}/mirage-sleep-${version}.tbz";
    hash = "sha256-J7cw7sE3EE3BIhSdwD1KV3VeXjEqviVmys3LgGhEE/A=";
  };

  propagatedBuildInputs = [
    duration
    lwt
  ];

  meta = {
    description = "Sleep operations for MirageOS";
    homepage = "https://github.com/mirage/mirage-sleep";
    changelog = "https://raw.githubusercontent.com/mirage/mirage-sleep/refs/tags/v${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
