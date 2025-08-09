{
  lib,
  buildDunePackage,
  fetchurl,
  domain-name,
  duration,
  fmt,
  ipaddr,
  logs,
}:

buildDunePackage rec {
  pname = "happy-eyeballs";
  version = "2.0.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/roburio/happy-eyeballs/releases/download/v${version}/happy-eyeballs-${version}.tbz";
    hash = "sha256-slVFiDApMbqF4Yhh5hCjraeCNJbU1JoZXpU1VsNR0mk=";
  };

  propagatedBuildInputs = [
    domain-name
    duration
    fmt
    ipaddr
    logs
  ];

  meta = {
    description = "Connecting to a remote host via IP version 4 or 6";
    homepage = "https://github.com/roburio/happy-eyeballs";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      vbgl
      ulrikstrid
    ];
  };
}
